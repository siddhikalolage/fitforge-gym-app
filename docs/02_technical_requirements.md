# FitForge AI Technical Requirements

## Purpose

This document defines the engineering requirements for building FitForge AI as a secure, maintainable Flutter Android application that can later connect to backend and AI services.

## Current Technology Stack

- Frontend: Flutter.
- Local storage: flutter_secure_storage for sensitive user profile and progress data.
- Legacy migration: shared_preferences retained for migration and non-sensitive simple values.
- Charts: fl_chart.
- Formatting/date utilities: intl.
- Tests: flutter_test.

## Target Architecture

The project should move toward Clean Architecture:

- Presentation layer: screens, widgets, view models/controllers.
- Domain layer: entities, value objects, use cases, repository contracts.
- Data layer: local data sources, remote data sources, repository implementations, DTOs.
- Core layer: errors, validation, constants, routing, security utilities.
- Shared layer: reusable UI components and helpers.

UI code must not communicate directly with databases, secure storage, network clients, or AI providers. It should call use cases or application services.

## Proposed Folder Structure

```text
lib/
  core/
    config/
    errors/
    security/
    validation/
  features/
    profile/
      data/
      domain/
      presentation/
    progress/
      data/
      domain/
      presentation/
    workout/
      data/
      domain/
      presentation/
    nutrition/
      data/
      domain/
      presentation/
  shared/
    widgets/
    theme/
    utils/
  main.dart
```

## Security Requirements

- Do not hardcode secrets, API keys, provider tokens, JWT secrets, or database credentials.
- Store sensitive local data using secure storage.
- Ask for user consent before storing profile/progress data.
- Provide user data deletion controls.
- Validate all user inputs before storage.
- Validate all AI-generated structured outputs before display or persistence.
- Use HTTPS for all backend communication.
- Use short-lived access tokens and refresh tokens when backend authentication is introduced.
- Use role-based access control for User, Trainer, Owner, and Admin roles.
- Hash passwords on backend using Argon2 or bcrypt if password auth is implemented.
- Disable or restrict Android backup for sensitive app data.
- Keep release signing keys outside source control.

## Android Requirements

- Maintain the real Android application ID `com.fitforgeai.app`.
- Set app label to `FitForge AI` or `FitForge`.
- Configure Android backup policy for sensitive storage.
- Confirm minimum Android SDK is compatible with secure storage dependencies.
- Add production launcher icons.
- Configure release signing before Play Store distribution.
- Keep debug and release configs separate.

## Data Requirements

Local MVP data:

- User profile.
- Progress history.
- Consent state if needed.
- Workout/diet plan cache if introduced later.

Future backend data:

- Accounts and roles.
- Gym organizations.
- Trainer-client relationships.
- Workout plans and workout logs.
- Nutrition plans and nutrition logs.
- Recovery metrics.
- Analytics and audit logs.
- Payments and subscriptions.

## AI Requirements

AI must not return arbitrary unvalidated text for core plans.

Allowed AI output should be structured:

- WorkoutPlan JSON.
- DietPlan JSON.
- RecoveryRecommendation JSON.
- ExerciseSubstitution JSON.
- ProgressInsight JSON.

Every AI response must pass schema validation before being shown or saved.

## Testing Requirements

Minimum tests before major feature growth:

- Unit tests for profile parsing and validation.
- Unit tests for secure storage migration.
- Unit tests for recommendation outputs.
- Widget tests for onboarding and dashboard flows.
- Integration test for profile creation to dashboard.
- Android smoke test after Android setup.

Future production tests:

- API tests.
- Security tests.
- Performance tests.
- Accessibility checks.
- Release build validation.

## Non-Functional Requirements

- App should launch quickly on Android.
- Dashboard should avoid unnecessary rebuilds.
- Long lists should use lazy rendering.
- Network calls should have timeouts and user-friendly errors.
- Offline support should be considered for profile and progress history.
- UI must be responsive on common Android phone sizes.

## Current Technical Gaps

- Clean Architecture is not implemented yet.
- No backend/API layer exists.
- No authentication or RBAC.
- Android release signing and production launcher icons are not configured yet.
- No structured AI schema validation yet.
- No crash reporting or monitoring.
- Test coverage is still small.
