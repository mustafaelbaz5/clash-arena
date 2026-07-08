import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ── Types ────────────────────────────────────────────────────────────────────

interface NotificationPayload {
  user_ids: string[];
  title: string;
  body: string;
  data?: Record<string, string>;
}

// ── Main Handler ─────────────────────────────────────────────────────────────

serve(async (req) => {
  try {
    const payload: NotificationPayload = await req.json();

    // 1. Validate payload
    if (!payload.user_ids?.length || !payload.title || !payload.body) {
      return new Response(JSON.stringify({ error: "Missing required fields" }), { status: 400 });
    }

    // 2. Init Supabase client with service role to bypass RLS
    const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

    // 3. Fetch all tokens for the given user_ids
    const { data: tokens, error } = await supabase.from("user_tokens").select("token").in("user_id", payload.user_ids);

    if (error) throw error;
    if (!tokens?.length) {
      return new Response(JSON.stringify({ message: "No tokens found for users" }), { status: 200 });
    }

    // 4. Get Firebase access token
    const accessToken = await getFirebaseAccessToken();

    // 5. Send notification to each token
    const results = await Promise.allSettled(
      tokens.map((row) =>
        sendFcmNotification({
          token: row.token,
          title: payload.title,
          body: payload.body,
          data: payload.data,
          accessToken,
        }),
      ),
    );

    const successCount = results.filter((r) => r.status === "fulfilled").length;
    const failCount = results.filter((r) => r.status === "rejected").length;

    return new Response(
      JSON.stringify({
        message: "Notifications sent",
        success: successCount,
        failed: failCount,
      }),
      { status: 200 },
    );
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500 });
  }
});

// ── Firebase Helpers ─────────────────────────────────────────────────────────

async function getFirebaseAccessToken(): Promise<string> {
  const serviceAccount = JSON.parse(Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!);

  const now = Math.floor(Date.now() / 1000);

  const claim = {
    iss: serviceAccount.client_email,
    sub: serviceAccount.client_email,
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
  };

  // Sign JWT with private key
  const jwt = await signJwt(claim, serviceAccount.private_key);

  // Exchange JWT for access token
  const response = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  const data = await response.json();
  return data.access_token;
}

async function sendFcmNotification({
  token,
  title,
  body,
  data,
  accessToken,
}: {
  token: string;
  title: string;
  body: string;
  data?: Record<string, string>;
  accessToken: string;
}) {
  const projectId = JSON.parse(Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!).project_id;

  const response = await fetch(`https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${accessToken}`,
    },
    body: JSON.stringify({
      message: {
        token,
        notification: { title, body },
        data: data ?? {},
      },
    }),
  });

  if (!response.ok) {
    const err = await response.json();
    throw new Error(`FCM error: ${JSON.stringify(err)}`);
  }
}

// ── JWT Helper ────────────────────────────────────────────────────────────────

async function signJwt(payload: Record<string, unknown>, privateKey: string): Promise<string> {
  const header = { alg: "RS256", typ: "JWT" };

  const encode = (obj: unknown) => btoa(JSON.stringify(obj)).replace(/=/g, "").replace(/\+/g, "-").replace(/\//g, "_");

  const signingInput = `${encode(header)}.${encode(payload)}`;

  const keyData = privateKey
    .replace(/-----BEGIN PRIVATE KEY-----/, "")
    .replace(/-----END PRIVATE KEY-----/, "")
    .replace(/\n/g, "");

  const binaryKey = Uint8Array.from(atob(keyData), (c) => c.charCodeAt(0));

  const cryptoKey = await crypto.subtle.importKey(
    "pkcs8",
    binaryKey,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );

  const signature = await crypto.subtle.sign("RSASSA-PKCS1-v1_5", cryptoKey, new TextEncoder().encode(signingInput));

  const encodedSignature = btoa(String.fromCharCode(...new Uint8Array(signature)))
    .replace(/=/g, "")
    .replace(/\+/g, "-")
    .replace(/\//g, "_");

  return `${signingInput}.${encodedSignature}`;
}
