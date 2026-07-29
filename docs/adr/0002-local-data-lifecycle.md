# ADR 0002: Local Data Lifecycle

## Status

Accepted

## Context

The MVP stores profile and progress data locally while the backend boundary is still being designed. Users need to understand where their data is stored and control it without exposing secure-storage implementation details.

## Decision

- Profile edits use the existing domain validators and replace the secure profile atomically after validation succeeds.
- Export creates a versioned JSON snapshot containing only profile and progress data, then uses the maintained share_plus platform share sheet after an explicit user action.
- Export does not include credentials, secure-storage keys, platform errors, or hidden metadata.
- Deletion requires confirmation and removes the secure profile, secure progress history, and legacy migration keys.
- The app does not copy health data to the clipboard or create unmanaged temporary files for export.

## Consequences

- Shared exports can leave the device; the UI explains this before the user chooses a destination.
- The export schema needs versioning when new local data types are added.
- Supabase account deletion and remote export must later follow the same explicit ownership and privacy contract.
