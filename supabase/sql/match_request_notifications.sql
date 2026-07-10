-- Inserts into user_notifications whenever a match_request is created or
-- its status changes, regardless of whether the change came from the
-- Flutter client (insert/reject) or approve_match_request (accept).
-- SECURITY DEFINER so it works even once RLS is enabled on
-- user_notifications later (per the soak-period plan).
create or replace function handle_match_request_notification()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_requester_name text;
  v_opponent_name text;
begin
  if TG_OP = 'INSERT' then
    select name into v_requester_name from users where id = NEW.requester_id;

    insert into user_notifications (user_id, notification_id, title, message, type, data, group_id, match_request_id)
    values (
      NEW.opponent_id,
      gen_random_uuid()::text,
      'New match request',
      coalesce(v_requester_name, 'Someone') || ' challenged you to a match',
      'match_request',
      jsonb_build_object('match_request_id', NEW.id),
      NEW.group_id,
      NEW.id
    );
    return NEW;
  end if;

  if TG_OP = 'UPDATE' and NEW.status is distinct from OLD.status then
    select name into v_opponent_name from users where id = NEW.opponent_id;

    if NEW.status = 'accepted' then
      insert into user_notifications (user_id, notification_id, title, message, type, data, group_id, match_request_id)
      values (
        NEW.requester_id,
        gen_random_uuid()::text,
        'Match request accepted',
        coalesce(v_opponent_name, 'Your opponent') || ' accepted your match request',
        'match_approved',
        jsonb_build_object('match_request_id', NEW.id, 'match_id', NEW.match_id),
        NEW.group_id,
        NEW.id
      );
    elsif NEW.status = 'rejected' then
      insert into user_notifications (user_id, notification_id, title, message, type, data, group_id, match_request_id)
      values (
        NEW.requester_id,
        gen_random_uuid()::text,
        'Match request rejected',
        coalesce(v_opponent_name, 'Your opponent') || ' rejected your match request',
        'match_rejected',
        jsonb_build_object('match_request_id', NEW.id),
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
