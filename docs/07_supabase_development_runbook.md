# Supabase Development Runbook

## Current State

The repository contains a reviewed first migration, but it has not been applied to a Supabase project. The current workstation does not have the Supabase CLI, Node.js, Docker, or psql available.

Do not connect Flutter to Supabase or push this migration to production until the checks below pass in a dedicated development project.

## Prerequisites

- Install and pin a supported Supabase CLI version for the team.
- Install Docker Desktop for the local Supabase stack.
- Authenticate with the Supabase CLI without committing the access token.
- Create separate development and production Supabase projects.

## Local Validation

Run from the repository root:

1. Run supabase init if supabase/config.toml does not exist; preserve the tracked migrations directory.
2. Run supabase start.
3. Run supabase db reset to apply migrations to a clean local database.
4. Run supabase test db to execute the tracked pgTAP migration tests.
5. Review the generated schema and RLS policies in local Studio.

## Migration Acceptance Checks

- A new Auth user creates exactly one empty public profile row.
- A user can read, insert, update, and delete only rows owned by that user ID.
- A second authenticated user cannot read or mutate the first user's profile or progress.
- Anonymous database requests cannot access either table.
- Profile and progress range constraints reject invalid values.
- Progress entries reject duplicate user/date pairs.
- Deleting an Auth user cascades to that user's profile and progress rows.
- Updating a profile cannot change its owner ID.
- The signup trigger does not copy unvalidated user metadata into health fields.

## Remote Deployment

For a new development project, link the project and run supabase db push only after local reset and acceptance checks pass. If the remote project already contains dashboard-created schema, capture it with supabase db pull before pushing local migrations.

Use a pull request for every migration. Never place project URLs, publishable keys, service-role keys, database passwords, or CLI tokens in this repository. The Flutter client may eventually receive only the project URL and publishable key through deployment configuration.
