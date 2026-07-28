# ADR 0001: Repository And Supabase Boundary

## Status

Accepted for the next implementation phase.

## Decision

FitForge AI remains local-first while the MVP is stabilized. Supabase will provide authentication and remote persistence after the repository has explicit local and remote repository boundaries.

The Flutter client may use only the Supabase project URL and publishable key. Secret and service-role keys belong only in backend-controlled environments. Row Level Security will be enabled for every user-data table, and policies will enforce ownership using the authenticated user ID.

## Rationale

- Local-first behavior preserves offline use and avoids forcing a network dependency into the current MVP.
- Repository interfaces allow remote sync without coupling screens to Supabase APIs.
- Database-enforced RLS provides a consistent authorization boundary across clients.
- Delaying migration prevents untested health-data synchronization and conflict behavior.

## Consequences

- The first Supabase phase requires an authentication decision and separate development/staging projects.
- Local and remote data models must share explicit validation and schema versions.
- Sync failures must be user-visible and recoverable.
- No Supabase credential may be committed to Git or embedded as a secret in a build artifact.
