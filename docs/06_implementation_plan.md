# FitForge AI Implementation Plan

## Purpose

This document defines the recommended build order for FitForge AI. The goal is to move from the current MVP to a secure Android-first product without skipping architecture, testing, or privacy work.

## Current Status

Implemented:

- Flutter app shell.
- Onboarding.
- Local profile.
- BMI calculation.
- Rule-based workout plan.
- Rule-based diet plan.
- Dashboard with progress chart.
- Progress logging.
- Secure local storage for profile/progress.
- Privacy consent.
- Profile editing.
- Privacy/data controls.
- Versioned local data export.
- Confirmed local data deletion.
- Web and Android platform folders.
- Basic tests for onboarding and secure storage migration.

Not implemented:

- Clean Architecture.
- Expanded progress tracking.
- Backend.
- Authentication.
- AI provider integration.
- Trainer/gym/admin roles.
- Production Android branding and release setup.

## Phase 1: Android Foundation And Security

Goal: make the Android app identity and local security production-aware.

Tasks:

1. Rename package/application ID from `com.example.gym_app`. Completed: `com.fitforgeai.app`.
2. Set Android app label to `FitForge` or `FitForge AI`. Completed: `FitForge`.
3. Configure Android backup policy for sensitive data. Completed: backup disabled and secure-storage shared preferences excluded from data extraction rules.
4. Confirm secure storage Android compatibility.
5. Replace default launcher icon.
6. Keep release signing out of source control.
7. Update README and engineering notes.
8. Run `flutter analyze` and `flutter test`.

Exit criteria:

- Android project no longer uses template identity.
- Sensitive local storage is protected from unsafe backup behavior.
- Tests pass.

## Phase 2: Clean Architecture Refactor

Goal: prepare the codebase for feature growth.

Tasks:

1. Create `core`, `features`, and `shared` folders.
2. Move profile model and storage logic into profile feature boundaries.
3. Move progress model/storage into progress feature boundaries.
4. Move workout planning into workout domain/data layers.
5. Move nutrition planning into nutrition domain/data layers.
6. Add repository contracts and local repository implementations.
7. Keep existing app behavior unchanged.
8. Run tests after each small migration.

Exit criteria:

- UI no longer depends directly on storage plugins.
- Recommendation logic is separated from screens.
- Existing behavior still works.

## Phase 3: MVP Feature Completion

Goal: make the app useful enough for real user testing.

Tasks:

1. Add profile editing. Completed with model validation and secure persistence.
2. Add water logging.
3. Add sleep logging.
4. Add steps logging.
5. Add workout completion tracking.
6. Add diet-followed tracking.
7. Expand dashboard cards and charts.
8. Add privacy/data controls screen. Completed with local-storage disclosure and actions.
9. Add local data export. Completed with versioned JSON shared through the system share sheet.
10. Add local data delete confirmation. Completed with secure and legacy-key deletion coverage.

Exit criteria:

- Users can update profile data without resetting.
- Users can track basic daily fitness habits.
- Users can control local data.

## Phase 4: Structured Plan Models

Goal: prepare for AI without depending on AI yet.

Tasks:

1. Define validated `WorkoutPlan` schema.
2. Define validated `DietPlan` schema.
3. Define `RecoveryScore` model.
4. Define `ProgressInsight` model.
5. Update rule-based recommendation engine to output the same structured models expected from future AI.
6. Add validation tests.

Exit criteria:

- Rule-based and future AI plans can share the same contract.
- Invalid plan data is rejected before display.

## Phase 5: Backend And Authentication

Goal: introduce secure accounts and sync.

Tasks:

1. Create backend project.
2. Add PostgreSQL schema.
3. Add authentication.
4. Add JWT access tokens and refresh tokens.
5. Add RBAC roles: user, trainer, owner, admin.
6. Add profile/progress sync APIs.
7. Add OpenAPI documentation.
8. Add rate limiting and audit logs.

Exit criteria:

- User accounts can sync profile/progress securely.
- API contracts are documented and tested.

## Phase 6: AI Integration

Goal: add AI-generated plans safely.

Tasks:

1. Add AI request service on backend.
2. Keep provider keys in environment variables or secret manager.
3. Generate structured outputs only.
4. Validate AI output schemas.
5. Store validated outputs.
6. Add user feedback loop.
7. Add fallbacks when AI fails.

Exit criteria:

- AI output never bypasses validation.
- Users get safe fallback recommendations if AI fails.

## Phase 7: Trainer, Gym, And Admin Platform

Goal: expand from individual app to ecosystem.

Tasks:

1. Trainer client list.
2. Trainer client progress dashboard.
3. Workout assignment.
4. Gym owner dashboard.
5. Membership tracking.
6. Admin user management.
7. Audit logs.
8. Role-based UI and API access.

Exit criteria:

- Multi-role workflows operate with RBAC.
- Sensitive actions are auditable.

## Immediate Next Sprint

Recommended next sprint:

1. Define Supabase development schema and migration ownership.
2. Define Auth onboarding and account-deletion behavior.
3. Write RLS policies for user-owned profile and progress rows.
4. Add repository interfaces before connecting screens to Supabase.
5. Run local Supabase security and ownership tests.

This sprint is small, necessary, and directly supports the goal of building a trustworthy Android startup product.
