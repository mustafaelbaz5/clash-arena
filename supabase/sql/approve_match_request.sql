-- The only path allowed to INSERT into `matches`. SECURITY DEFINER so it
-- bypasses RLS for its internal writes, but every write is gated on the
-- checks below — the caller never gets to decide who won or which group
-- a match belongs to (that was already fixed at request-creation time;
-- this only copies the claimed result over once the opponent confirms it).
create or replace function approve_match_request(p_request_id uuid)
returns table (match_id uuid, group_id uuid)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request match_requests;
  v_match_id uuid;
begin
  select * into v_request from match_requests where id = p_request_id;

  if v_request.id is null then
    raise exception 'Match request not found' using errcode = 'PGRST404';
  end if;

  if v_request.opponent_id <> auth.uid() then
    raise exception 'Only the opponent can approve this request' using errcode = '42501';
  end if;

  if v_request.status <> 'pending' then
    raise exception 'Request is already %', v_request.status using errcode = 'P0001';
  end if;

  if v_request.expires_at is not null and v_request.expires_at < now() then
    update match_requests set status = 'expired' where id = v_request.id;
    raise exception 'Request has expired' using errcode = 'P0001';
  end if;

  insert into matches (group_id, winner_id, loser_id, winner_score, loser_score, match_request_id, status)
    values (v_request.group_id, v_request.winner_id, v_request.loser_id, v_request.winner_score, v_request.loser_score, v_request.id, 'completed')
    returning id into v_match_id;

  update match_requests
    set status = 'accepted', match_id = v_match_id, responded_at = now(), responded_by = auth.uid()
    where id = v_request.id;

  return query select v_match_id, v_request.group_id;
end;
$$;

grant execute on function approve_match_request(uuid) to authenticated;
