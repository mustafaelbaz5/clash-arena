-- Fires on every group_members insert: welcomes the new member and lets
-- existing members know someone joined. For a brand-new group (the
-- creator's own owner row), the "notify others" query naturally finds no
-- other members yet, so only the welcome notification is sent.
create or replace function handle_group_member_joined_notification()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_new_member_name text;
  v_group_name text;
begin
  select name into v_new_member_name from users where id = NEW.user_id;
  select name into v_group_name from groups where id = NEW.group_id;

  insert into user_notifications (user_id, notification_id, title, message, type, data, group_id)
  values (
    NEW.user_id,
    gen_random_uuid()::text,
    'Welcome to ' || coalesce(v_group_name, 'the group'),
    'You joined ' || coalesce(v_group_name, 'a new group') || '. Good luck!',
    'welcome',
    jsonb_build_object('group_id', NEW.group_id, 'group_name', v_group_name),
    NEW.group_id
  );

  insert into user_notifications (user_id, notification_id, title, message, type, data, group_id)
  select
    gm.user_id,
    gen_random_uuid()::text,
    'New group member',
    coalesce(v_new_member_name, 'Someone') || ' joined ' || coalesce(v_group_name, 'your group') || '.',
    'group_invite',
    jsonb_build_object(
      'group_id', NEW.group_id,
      'group_name', v_group_name,
      'new_member_id', NEW.user_id,
      'new_member_name', v_new_member_name
    ),
    NEW.group_id
  from group_members gm
  where gm.group_id = NEW.group_id and gm.user_id <> NEW.user_id;

  return NEW;
end;
$$;

drop trigger if exists trg_group_member_joined_notify on group_members;

create trigger trg_group_member_joined_notify
after insert on group_members
for each row execute function handle_group_member_joined_notification();
