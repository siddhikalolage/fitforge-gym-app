# ADR 0003: Supabase Auth And RLS Boundary

## Status

Accepted

## Context

FitForge needs remote accounts and synchronization without duplicating identity management or trusting client-side ownership checks. The current app remains local-first, so the first remote migration must be narrow, reviewable, and safe to apply to a development project.

## Decision

- Supabase Auth owns identities in auth.users. FitForge does not create a public users table, store password hashes, or reference mutable Auth columns.
- The first remote schema contains only public.profiles and public.progress_entries.
- Both tables reference auth.users(id) with on delete cascade.
- Profile and progress rows are private to the authenticated owner through authenticated-only RLS policies using auth.uid().
- Insert and update policies validate ownership both before and after writes.
- Anonymous database access is revoked for these tables.
- A security-definer signup trigger creates an empty profile row with an empty search path and no user-provided fields.
- Database checks mirror the validated local profile and progress ranges.
- Flutter remote integration is deferred until this migration is applied and tested in a dedicated development project.

## Consequences

- The client must authenticate before reading or writing remote data.
- Onboarding completion is represented explicitly because Auth signup and profile completion are separate operations.
- Deleting an Auth user cascades to the two user-owned tables; account deletion must still be tested in staging before production.
- Future trainer, gym, AI, and audit tables require separate migrations and explicit ownership policies.
- Service-role credentials remain server-side and must never be placed in Flutter configuration.
