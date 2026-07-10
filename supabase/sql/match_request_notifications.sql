-- Inserts into user_notifications whenever a match_request is created or
-- its status changes, regardless of whether the change came from the
-- Flutter client (insert/reject) or approve_match_request (accept).
-- SECURITY DEFINER so it works even once RLS is enabled on
-- user_notifications later (per the soak-period plan).
--
-- The `data` jsonb payload is a snapshot of the match facts at the time of
-- the event (names, scores, group) so the notification details screen can
-- render richly without an extra round trip or depending on the
-- match_request row still existing/being unchanged later. Live values that
-- genuinely change over time (e.g. current leaderboard rank) are
-- deliberately NOT stored here — the client fetches those fresh.
create or replace function handle_match_request_notification()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_requester_name text;
  v_opponent_name text;
  v_winner_name text;
  v_loser_name text;
  v_group_name text;
  v_data jsonb;
begin
  select name into v_requester_name from users where id = NEW.requester_id;
  select name into v_opponent_name from users where id = NEW.opponent_id;
  select name into v_winner_name from users where id = NEW.winner_id;
  select name into v_loser_name from users where id = NEW.loser_id;
  select name into v_group_name from groups where id = NEW.group_id;

  v_data := jsonb_build_object(
    'match_request_id', NEW.id,
    'group_id', NEW.group_id,
    'group_name', v_group_name,
    'requester_id', NEW.requester_id,
    'requester_name', v_requester_name,
    'opponent_id', NEW.opponent_id,
    'opponent_name', v_opponent_name,
    'winner_id', NEW.winner_id,
    'winner_name', v_winner_name,
    'loser_id', NEW.loser_id,
    'loser_name', v_loser_name,
    'winner_score', NEW.winner_score,
    'loser_score', NEW.loser_score,
    'note', NEW.note
  );

  if TG_OP = 'INSERT' then
    insert into user_notifications (user_id, notification_id, title, message, type, data, group_id, match_request_id)
    values (
      NEW.opponent_id,
      gen_random_uuid()::text,
      'New match request',
      coalesce(v_requester_name, 'Someone') || ' submitted a result: ' ||
        coalesce(v_winner_name, '?') || ' ' || NEW.winner_score || ' - ' || NEW.loser_score || ' ' || coalesce(v_loser_name, '?') ||
        '. Review and respond.',
      'match_request',
      v_data,
      NEW.group_id,
      NEW.id
    );
    return NEW;
  end if;

  if TG_OP = 'UPDATE' and NEW.status is distinct from OLD.status then
    v_data := v_data || jsonb_build_object('match_id', NEW.match_id);

    if NEW.status = 'accepted' then
      insert into user_notifications (user_id, notification_id, title, message, type, data, group_id, match_request_id)
      values (
        NEW.requester_id,
        gen_random_uuid()::text,
        'Match request accepted',
        coalesce(v_opponent_name, 'Your opponent') || ' confirmed the match: ' ||
          coalesce(v_winner_name, '?') || ' ' || NEW.winner_score || ' - ' || NEW.loser_score || ' ' || coalesce(v_loser_name, '?') || '.',
        'match_approved',
        v_data,
        NEW.group_id,
        NEW.id
      );
    elsif NEW.status = 'rejected' then
      insert into user_notifications (user_id, notification_id, title, message, type, data, group_id, match_request_id)
      values (
        NEW.requester_id,
        gen_random_uuid()::text,
        'Match request rejected',
        coalesce(v_opponent_name, 'Your opponent') || ' rejected the reported result (' ||
          coalesce(v_winner_name, '?') || ' ' || NEW.winner_score || ' - ' || NEW.loser_score || ' ' || coalesce(v_loser_name, '?') || ').',
        'match_rejected',
        v_data,
        NEW.group_id,
        NEW.id
      );
    elsif NEW.status = 'expired' then
      -- 'expired' isn't one of the allowed notification types, so this
      -- reuses 'system' — it's a timeout, not a decision by the opponent.
      insert into user_notifications (user_id, notification_id, title, message, type, data, group_id, match_request_id)
      values (
        NEW.requester_id,
        gen_random_uuid()::text,
        'Match request expired',
        coalesce(v_opponent_name, 'Your opponent') || ' never responded to your match request (' ||
          coalesce(v_winner_name, '?') || ' ' || NEW.winner_score || ' - ' || NEW.loser_score || ' ' || coalesce(v_loser_name, '?') || '). It has expired.',
        'system',
        v_data,
        NEW.group_id,
        NEW.id
      );
    end if;
  end if;

  return NEW;
end;
$$;

drop trigger if exists trg_match_request_notify on match_requests;

create trigger trg_match_request_notify
after insert or update on match_requests
for each row execute function handle_match_request_notification();
