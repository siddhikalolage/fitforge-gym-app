# FitForge AI Engineering Notes

## Source Documents

- FitForge AI.pdf
- FitForge AI Codex.pdf

## Product Direction

FitForge AI is intended to become an AI-powered personalized fitness ecosystem for individual users, trainers, gym owners, and administrators. The long-term platform should support adaptive workout planning, nutrition guidance, progress analytics, recovery recommendations, gamification, social/community workflows, trainer operations, and gym management.

## Engineering Principles

All implementation work should favor clean architecture, modular responsibilities, validated data, maintainability, security, performance, testability, and incremental delivery. UI code should not communicate directly with future databases or provider APIs; data access and business logic should remain isolated behind services or repositories.

## Security Baseline

- Do not hardcode API keys, provider tokens, JWT secrets, database credentials, or payment secrets.
- Validate user input before storage or display.
- Treat AI responses as structured data that must be validated before use.
- Keep sensitive data local only for the current MVP; future backend work should use HTTPS, hashed passwords, role-based access control, rate limiting, audit logging, and encrypted storage where applicable.

## Current MVP Scope

The current Flutter app provides local onboarding, BMI calculation, personalized workout and diet recommendations, profile reset, and basic progress tracking using SharedPreferences. It is not yet a full AI/backend platform and does not currently include authentication, backend APIs, payments, trainer/gym owner portals, real AI provider integration, or production monitoring.

## Stability Pass Completed

- StorageService is singleton-backed and self-initializing, preventing screens from using SharedPreferences before setup.
- Saved profile and progress JSON parsing is defensive and recovers from malformed local data by clearing only the affected record.
- Onboarding validates profile input and avoids parse exceptions from malformed age, height, or weight values.
- BMI preview updates as height and weight change.
- Dashboard progress logging validates weight input, disposes its text controller, and guards async state updates.
- Missing-profile recovery now routes users back to onboarding.
- Corrupted/non-portable UI separators were replaced with source-safe text or Material icons.

## Next Recommended Increments

1. Add unit and widget tests for profile parsing, storage recovery, onboarding validation, recommendation outputs, and dashboard progress logging.
2. Introduce a cleaner folder structure with domain, data, and presentation boundaries before adding backend or AI integrations.
3. Add structured models for workout plans, nutrition plans, recovery scores, and AI-generated outputs.
4. Replace local-only persistence with repositories so SharedPreferences can remain an offline implementation detail.
5. Add authentication and role models only when a backend boundary exists.