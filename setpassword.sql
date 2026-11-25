create extension if not exists pgcrypto;
update auth.users
set encrypted_password = crypt('Admin@12345', gen_salt('bf')),
    email_confirmed_at = coalesce(email_confirmed_at, now())
where email = 'manpreetsirohi26@gmail.com';