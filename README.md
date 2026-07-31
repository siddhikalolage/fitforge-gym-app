# FitForge AI

FitForge AI is a Flutter fitness app focused on personalized workout, nutrition, and progress guidance. The current product is an Android-first MVP with secure local storage and a roadmap toward an AI-powered fitness ecosystem for individuals, trainers, gyms, and administrators.

## Current MVP

- Onboarding with profile, body metrics, goal, and activity level.
- Secure local storage for profile and progress data.
- BMI calculation and profile-based recommendations.
- Rule-based workout and diet plans.
- Dashboard with weight progress logging.
- Profile reset and local data cleanup.
- Web and Android project scaffolding.

## Security Posture

- Sensitive profile and progress data use `flutter_secure_storage`.
- Onboarding asks for consent before saving local profile/progress data.
- Android backup is disabled to reduce risk around sensitive local data.
- No API keys, provider tokens, or backend secrets should be committed.

## Development Setup

```powershell
flutter pub get
flutter analyze
flutter test
```

To run on Android:

```powershell
flutter devices
flutter run
```

To run on Chrome for quick UI checks:

```powershell
flutter run -d chrome
```

## Documentation

- `docs/project_status.md`
- `docs/adr/0001-repository-and-supabase-boundary.md`
- `CHANGELOG.md`
- `docs/01_product_requirements.md`
- `docs/02_technical_requirements.md`
- `docs/03_app_flow.md`
- `docs/04_ui_ux_design_brief.md`
- `docs/05_backend_schema.md`
- `docs/06_implementation_plan.md`

## Immediate Next Work

1. Apply and test the reviewed Supabase Auth/RLS migration in development.
2. Introduce repository boundaries before Flutter remote integration.
3. Configure release signing outside source control.
4. Expand progress tracking for water, sleep, steps, workouts, and nutrition compliance.
