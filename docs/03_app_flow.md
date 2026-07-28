# FitForge AI App Flow

## Purpose

This document defines how users move through FitForge AI. It starts with the current MVP flow and expands into future flows for AI, trainers, gym owners, and administrators.

## Current MVP Flow

### First Launch

```text
Launch app
  -> Check secure local profile
  -> No profile found
  -> Onboarding
  -> Save profile after consent
  -> Home tabs
```

### Returning User

```text
Launch app
  -> Check secure local profile
  -> Profile found
  -> Dashboard
```

### Onboarding Flow

```text
Welcome
  -> Personal info
    -> name
    -> age
    -> gender
  -> Body metrics
    -> height
    -> weight
    -> BMI preview
  -> Goals
    -> goal
    -> activity level
    -> secure local data consent
  -> Create plan
```

### Main Navigation

```text
Home
  -> Dashboard
  -> Workout
  -> Diet
  -> Profile
```

### Dashboard Flow

```text
Dashboard
  -> View BMI summary
  -> View quick stats
  -> View weight progress chart
  -> Log today's progress
    -> Validate weight
    -> Save progress securely
    -> Refresh chart
```

### Workout Flow

```text
Workout tab
  -> View weekly plan
  -> Select day
  -> View exercises, sets, reps, rest, difficulty
  -> Rest day state when no exercises
```

### Diet Flow

```text
Diet tab
  -> View daily calories
  -> View water recommendation
  -> View meals
  -> View macro summary
  -> View notes and tips
```

### Profile Flow

```text
Profile tab
  -> View profile details
  -> Reset profile
    -> Confirm deletion
    -> Clear secure local data
    -> Return to onboarding
```

## Near-Term Required Flows

### Edit Profile

```text
Profile
  -> Edit profile
  -> Update age, height, weight, activity, goal
  -> Validate input
  -> Save securely
  -> Regenerate local recommendations
```

### Data Control

```text
Profile
  -> Privacy and data
  -> Export local data
  -> Delete local data
  -> View data storage explanation
```

### Expanded Progress Tracking

```text
Dashboard
  -> Log progress
  -> Weight
  -> Water
  -> Sleep
  -> Steps
  -> Workout completed
  -> Diet followed
```

## Future AI Flow

```text
Profile and history data
  -> Build structured AI request
  -> Send to backend
  -> AI provider generates structured output
  -> Backend validates schema
  -> App displays validated plan
  -> User feedback updates future recommendations
```

## Future Trainer Flow

```text
Trainer login
  -> Client list
  -> Client profile
  -> Assign workout plan
  -> Assign diet guidance
  -> Review progress
  -> Send feedback
```

## Future Gym Owner Flow

```text
Owner login
  -> Gym dashboard
  -> Member engagement
  -> Trainer performance
  -> Attendance
  -> Revenue analytics
```

## Future Admin Flow

```text
Admin login
  -> Users
  -> Gyms
  -> Roles
  -> Audit logs
  -> System health
```

## Flow Principles

- Users should always understand why data is requested.
- Data entry should be fast and forgiving.
- Sensitive actions require confirmation.
- Dashboards should show useful status first, not decoration.
- AI output should be shown only after validation.
