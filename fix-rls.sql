-- FIX: contact form + cover image upload
-- Supabase SQL Editor me paste karke RUN karo. Safe hai, dobara chala sakte ho.

-- ===== A) messages table: visitors ka contact form =====
create table if not exists public.messages (
  id          bigint generated always as identity primary key,
  name        text not null check (char_length(name) between 1 and 100),
  email       text not null check (char_length(email) between 5 and 200 and email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  message     text not null check (char_length(message) between 1 and 2000),
  created_at  timestamptz not null default now()
);
alter table public.messages enable row level security;

drop policy if exists "messages send" on public.messages;
drop policy if exists "messages read" on public.messages;
drop policy if exists "messages delete" on public.messages;

create policy "messages send" on public.messages
  for insert to anon, authenticated
  with check (true);

create policy "messages read" on public.messages
  for select to authenticated
  using (public.is_admin());

create policy "messages delete" on public.messages
  for delete to authenticated
  using (public.is_admin());

grant usage on schema public to anon, authenticated, service_role;
grant select, insert on public.messages to anon;
grant select, delete on public.messages to authenticated;
grant all on public.messages to service_role;

-- ===== B) storage bucket: cover images upload =====
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('covers', 'covers', true, 2097152, array['image/jpeg','image/png','image/webp','image/gif'])
on conflict (id) do update
  set public = true,
      file_size_limit = 2097152,
      allowed_mime_types = array['image/jpeg','image/png','image/webp','image/gif'];

drop policy if exists "covers read" on storage.objects;
drop policy if exists "covers insert" on storage.objects;
drop policy if exists "covers update" on storage.objects;
drop policy if exists "covers delete" on storage.objects;

create policy "covers read" on storage.objects
  for select to anon, authenticated
  using (bucket_id = 'covers');

create policy "covers insert" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'covers' and public.is_admin());

create policy "covers update" on storage.objects
  for update to authenticated
  using (bucket_id = 'covers' and public.is_admin())
  with check (bucket_id = 'covers' and public.is_admin());

create policy "covers delete" on storage.objects
  for delete to authenticated
  using (bucket_id = 'covers' and public.is_admin());

-- ===== C) Verify: neeche 3 rows dikhni chahiye =====
select 'messages_policies' as what, policyname, cmd, roles
from pg_policies where tablename = 'messages'
union all
select 'covers_policies', policyname, cmd, roles
from pg_policies where tablename = 'objects' and policyname like 'covers%'
union all
select 'bucket', id, case when public then 'public' else 'private' end, ''
from storage.buckets where id = 'covers';
