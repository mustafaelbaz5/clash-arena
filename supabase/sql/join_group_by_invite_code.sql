-- Private groups aren't SELECT-able by non-members under RLS (not public,
-- not yet a member), so the invite-code lookup + join must happen
-- server-side. SECURITY DEFINER bypasses that for this one controlled path.
create or replace function join_group_by_invite_code(p_invite_code text)
returns groups
language plpgsql
security definer
set search_path = public
as $$
declare
  v_group groups;
  v_member_count int;
begin
  select * into v_group from groups
    where invite_code = upper(p_invite_code) and archived_at is null;

  if v_group.id is null then
    raise exception 'Invalid invite code' using errcode = 'PGRST404';
  end if;

  select count(*) into v_member_count from group_members where group_id = v_group.id;
  if v_member_count >= v_group.max_members then
    raise exception 'Group is full' using errcode = 'P0001';
  end if;

  insert into group_members (group_id, user_id, role)
    values (v_group.id, auth.uid(), 'member')
    on conflict (group_id, user_id) do nothing;

  return v_group;
end;
$$;

grant execute on function join_group_by_invite_code(text) to authenticated;
