create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  name text,
  age smallint,
  gender text,
  height_cm numeric(6, 2),
  weight_kg numeric(6, 2),
  activity_level text,
  goal text,
  onboarding_completed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint profiles_name_check
    check (name is null or char_length(btrim(name)) between 1 and 100),
  constraint profiles_age_check
    check (age is null or age between 13 and 100),
  constraint profiles_gender_check
    check (gender is null or gender in ('male', 'female')),
  constraint profiles_height_check
    check (height_cm is null or height_cm between 80 and 250),
  constraint profiles_weight_check
    check (weight_kg is null or weight_kg between 20 and 300),
  constraint profiles_activity_check
    check (
      activity_level is null
      or activity_level in (
        'sedentary',
        'light',
        'moderate',
        'active',
        'very_active'
      )
    ),
  constraint profiles_goal_check
    check (
      goal is null
      or goal in ('lose_weight', 'maintain', 'gain_muscle')
    ),
  constraint profiles_onboarding_check
    check (
      not onboarding_completed
      or (
        name is not null
        and age is not null
        and gender is not null
        and height_cm is not null
        and weight_kg is not null
        and activity_level is not null
        and goal is not null
      )
    )
);

create table public.progress_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  entry_date date not null,
  weight_kg numeric(6, 2) not null,
  bmi numeric(6, 2) not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint progress_entries_weight_check
    check (weight_kg between 20 and 300),
  constraint progress_entries_bmi_check
    check (bmi > 0 and bmi <= 500),
  constraint progress_entries_user_date_unique
    unique (user_id, entry_date)
);

create index progress_entries_user_date_idx
  on public.progress_entries (user_id, entry_date desc);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $function$
begin
  new.updated_at = now();
  return new;
end;
$function$;

create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

create trigger progress_entries_set_updated_at
before update on public.progress_entries
for each row execute function public.set_updated_at();

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $function$
begin
  insert into public.profiles (id)
  values (new.id)
  on conflict (id) do nothing;
  return new;
end;
$function$;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

revoke all on table public.profiles from anon;
revoke all on table public.progress_entries from anon;

grant select, insert, update, delete
on table public.profiles
to authenticated;

grant select, insert, update, delete
on table public.progress_entries
to authenticated;

alter table public.profiles enable row level security;
alter table public.progress_entries enable row level security;

create policy profiles_select_own
on public.profiles
for select
to authenticated
using ((select auth.uid()) = id);

create policy profiles_insert_own
on public.profiles
for insert
to authenticated
with check ((select auth.uid()) = id);

create policy profiles_update_own
on public.profiles
for update
to authenticated
using ((select auth.uid()) = id)
with check ((select auth.uid()) = id);

create policy profiles_delete_own
on public.profiles
for delete
to authenticated
using ((select auth.uid()) = id);

create policy progress_entries_select_own
on public.progress_entries
for select
to authenticated
using ((select auth.uid()) = user_id);

create policy progress_entries_insert_own
on public.progress_entries
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy progress_entries_update_own
on public.progress_entries
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy progress_entries_delete_own
on public.progress_entries
for delete
to authenticated
using ((select auth.uid()) = user_id);

revoke execute on function public.set_updated_at() from public, anon, authenticated;
revoke execute on function public.handle_new_user() from public, anon, authenticated;
