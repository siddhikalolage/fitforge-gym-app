# FitForge AI Project Status

## Current Release Position

FitForge AI is an Android-first, local-first MVP. The app currently supports onboarding, BMI calculation, rule-based workout and diet recommendations, weight progress logging, secure local storage, and profile reset.

It is not production-ready for public health-data use. Authentication, backend synchronization, Supabase RLS enforcement, profile editing, data export, expanded progress tracking, release signing, monitoring, and health-safety review remain incomplete. Domain validation rejects unsupported profile and progress values before secure persistence, and storage failures now use safe user-facing error states.

## Repository Baseline

- The `main` branch is the source branch for the MVP.
- Generated build output, local SDK paths, credentials, and secrets must not be committed.
- Every product or security change requires a matching documentation update.
- Every feature change requires tests or a documented reason why testing is not applicable.
- Remote updates should be made only after formatting, static analysis, and tests pass.

## Delivery Gates

Before merging a change:

1. The requirement and acceptance criteria are written down.
2. Existing Flutter or vetted package capabilities are checked before new logic is added.
3. Security and privacy impact is reviewed.
4. `dart format`, `flutter analyze`, and `flutter test` pass.
5. Documentation and changelog entries match the implementation.

## Next Approved Sequence

1. Add profile editing, privacy controls, export, and deletion coverage.
2. Create Supabase development infrastructure with Auth and RLS.
3. Add local and Supabase repository implementations with offline fallback.
4. Enable remote synchronization only after ownership and conflict tests pass.
