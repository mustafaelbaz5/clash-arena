import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ── Types ────────────────────────────────────────────────────────────────────

interface ApproveMatchPayload {
  request_id: string;
}

// ── Main Handler ─────────────────────────────────────────────────────────────
//
// The only path allowed to INSERT into `matches`. Runs with the service role
// key so it can bypass RLS, but every write is gated on server-side checks
// below — the client never gets to decide who won or which group a match
// belongs to.

serve(async (req) => {
  try {
    const payload: ApproveMatchPayload = await req.json();
    if (!payload.request_id) {
      return json({ error: "Missing request_id" }, 400);
    }

    // 1. Identify the caller from their JWT (verify_jwt=true already
    // validated the token; this just decodes who it belongs to).
    const authClient = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_ANON_KEY")!, {
      global: { headers: { Authorization: req.headers.get("Authorization")! } },
    });
    const {
      data: { user },
      error: authError,
    } = await authClient.auth.getUser();
    if (authError || !user) {
      return json({ error: "Unauthorized" }, 401);
    }

    // 2. Service-role client for the privileged read/write below.
    const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

    const { data: matchRequest, error: fetchError } = await supabase
      .from("match_requests")
      .select("*")
      .eq("id", payload.request_id)
      .single();

    if (fetchError || !matchRequest) {
      return json({ error: "Match request not found" }, 404);
    }
    if (matchRequest.opponent_id !== user.id) {
      return json({ error: "Only the opponent can approve this request" }, 403);
    }
    if (matchRequest.status !== "pending") {
      return json({ error: `Request is already ${matchRequest.status}` }, 409);
    }
    if (matchRequest.expires_at && new Date(matchRequest.expires_at) < new Date()) {
      await supabase.from("match_requests").update({ status: "expired" }).eq("id", matchRequest.id);
      return json({ error: "Request has expired" }, 409);
    }

    // 3. Derive winner/loser from the two submitted scores. Ties resolve to
    // the requester, matching the existing add_match tie-handling behavior.
    const requesterWins = matchRequest.requester_score >= matchRequest.opponent_score;
    const winnerId = requesterWins ? matchRequest.requester_id : matchRequest.opponent_id;
    const loserId = requesterWins ? matchRequest.opponent_id : matchRequest.requester_id;
    const winnerScore = requesterWins ? matchRequest.requester_score : matchRequest.opponent_score;
    const loserScore = requesterWins ? matchRequest.opponent_score : matchRequest.requester_score;

    const { data: insertedMatch, error: insertError } = await supabase
      .from("matches")
      .insert({
        group_id: matchRequest.group_id,
        winner_id: winnerId,
        loser_id: loserId,
        winner_score: winnerScore,
        loser_score: loserScore,
        match_request_id: matchRequest.id,
        status: "completed",
      })
      .select()
      .single();

    if (insertError) throw insertError;

    const { error: updateError } = await supabase
      .from("match_requests")
      .update({
        status: "approved",
        match_id: insertedMatch.id,
        responded_at: new Date().toISOString(),
      })
      .eq("id", matchRequest.id);

    if (updateError) throw updateError;

    // TODO(phase 1c/2b): invoke send_notification and check_achievements here.

    return json({ match_id: insertedMatch.id, group_id: matchRequest.group_id }, 200);
  } catch (err) {
    return json({ error: err.message }, 500);
  }
});

function json(body: Record<string, unknown>, status: number): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}
