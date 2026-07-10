-- Creates a group and adds the caller as its owner in one atomic,
-- RLS-bypassing step. This avoids a chicken-and-egg RLS problem: plain
-- client INSERT ... RETURNING requires the new row to pass the table's
-- SELECT policy (is_public = true OR is_group_member(id)) to be returned,
-- but a private group's owner group_members row doesn't exist until the
-- second insert — so the very first INSERT's RETURNING fails even though
-- its own WITH CHECK condition was satisfied.
create or replace function create_group(
  p_name text,
  p_description text,
  p_is_public boolean,
  p_max_members int
)
returns groups
language plpgsql
security definer
set search_path = public
as $$
declare
  v_group groups;
begin
  insert into groups (name, description, is_public, max_members, created_by)
    values (p_name, p_description, p_is_public, p_max_members, auth.uid())
    returning * into v_group;

  insert into group_members (group_id, user_id, role)
    values (v_group.id, auth.uid(), 'owner');

  return v_group;
end;
$$;

grant execute on function create_group(text, text, boolean, int) to authenticated;
