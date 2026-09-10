-- Run this once in Supabase: Database (left sidebar) → SQL Editor → New query
-- Paste everything below, then click "Run".

create table if not exists app_data (
  key text primary key,
  value jsonb not null,
  updated_at timestamptz not null default now()
);

-- Lock the table down so only signed-in staff can read or write it
alter table app_data enable row level security;

create policy "Signed-in staff can read app data"
  on app_data for select
  using (auth.role() = 'authenticated');

create policy "Signed-in staff can insert app data"
  on app_data for insert
  with check (auth.role() = 'authenticated');

create policy "Signed-in staff can update app data"
  on app_data for update
  using (auth.role() = 'authenticated');

create policy "Signed-in staff can delete app data"
  on app_data for delete
  using (auth.role() = 'authenticated');

-- Turn on live sync so every signed-in device sees changes instantly
alter publication supabase_realtime add table app_data;
