-- Scheduled hourly via pg_cron: flips stale pending requests to 'expired'.
-- Without this, a request nobody responds to sits as 'pending' forever.
create extension if not exists pg_cron with schema extensions;

create or replace function expire_match_requests()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update match_requests
  set status = 'expired'
  where status = 'pending'
    and expires_at is not null
    and expires_at < now();
end;
$$;

-- Safe to re-run: unschedule first so this doesn't create duplicate jobs.
select cron.unschedule('expire-match-requests-hourly')
where exists (
  select 1 from cron.job where jobname = 'expire-match-requests-hourly'
);

select cron.schedule(
  'expire-match-requests-hourly',
  '0 * * * *',
  $$select expire_match_requests();$$
);
