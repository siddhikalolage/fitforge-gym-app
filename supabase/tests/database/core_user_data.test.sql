begin;

select plan(10);

select ok(
  to_regclass('public.profiles') is not null,
  'profiles table exists'
);

select ok(
  to_regclass('public.progress_entries') is not null,
  'progress_entries table exists'
);

select ok(
  exists (
    select 1
    from pg_index
    where indrelid = 'public.profiles'::regclass
      and indisprimary
  ),
  'profiles has a primary key'
);

select ok(
  exists (
    select 1
    from pg_index
    where indrelid = 'public.progress_entries'::regclass
      and indisprimary
  ),
  'progress_entries has a primary key'
);

select policies_are(
  'public',
  'profiles',
  array[
    'profiles_select_own',
    'profiles_insert_own',
    'profiles_update_own',
    'profiles_delete_own'
  ],
  'profiles has exactly the owner policies'
);

select policies_are(
  'public',
  'progress_entries',
  array[
    'progress_entries_select_own',
    'progress_entries_insert_own',
    'progress_entries_update_own',
    'progress_entries_delete_own'
  ],
  'progress_entries has exactly the owner policies'
);

select ok(
  (select relrowsecurity from pg_class where oid = 'public.profiles'::regclass),
  'profiles has RLS enabled'
);

select ok(
  (
    select relrowsecurity
    from pg_class
    where oid = 'public.progress_entries'::regclass
  ),
  'progress_entries has RLS enabled'
);

select ok(
  (
    select prosecdef
    from pg_proc
    where oid = 'public.handle_new_user()'::regprocedure
  ),
  'new-user trigger is security definer'
);

select ok(
  to_regclass('public.progress_entries_user_date_unique') is not null,
  'progress date uniqueness index exists'
);

select * from finish();

rollback;
