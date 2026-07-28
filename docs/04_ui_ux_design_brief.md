# FitForge AI UI/UX Design Brief

## Purpose

This document defines the design direction for FitForge AI so the app feels trustworthy, motivating, and practical for repeated fitness use.

## Design Goals

- Help users understand their current fitness status quickly.
- Make logging progress fast and low-friction.
- Make recommendations feel personalized, not generic.
- Build trust around health data and privacy.
- Keep the interface clean enough for daily use.

## Product Personality

FitForge AI should feel:

- Confident.
- Supportive.
- Modern.
- Practical.
- Data-aware.
- Not overly playful or childish.

## Visual Direction

Current app uses a dark theme with orange accents. This is acceptable for MVP, but it should evolve into a polished fitness identity.

Recommended direction:

- Dark base for focus and gym-like feel.
- Orange accent for energy and action.
- Green for success/healthy ranges.
- Blue for hydration/recovery.
- Red only for risk/warnings.
- Avoid overusing one color everywhere.

## Core Screens

### Onboarding

Goal: collect only necessary data and explain why it is needed.

Required UX:

- Clear step-by-step flow.
- Visible BMI preview after height and weight.
- Privacy consent before saving profile/progress data.
- Input validation with friendly messages.
- No overwhelming medical language.

### Dashboard

Goal: show the user's current status and progress.

Required UX:

- Greeting and BMI summary.
- Quick stats.
- Progress chart.
- Primary action to log today's progress.
- Future cards for water, sleep, workout consistency, and goal completion.

### Workout

Goal: show what the user should do today and this week.

Required UX:

- Day selector.
- Workout focus.
- Exercise list with sets, reps, rest, and difficulty.
- Rest day state.
- Future completion tracking.

### Diet

Goal: show simple nutrition guidance.

Required UX:

- Daily calorie target.
- Meal sections.
- Macro summary.
- Notes/tips.
- Future food preference and Indian diet support.

### Profile

Goal: let users understand and control their data.

Required UX:

- Profile details.
- Goal and activity level.
- Edit profile.
- Privacy/data controls.
- Reset/delete data confirmation.

## Accessibility Requirements

- Text must be readable on small Android screens.
- Touch targets should be large enough for mobile use.
- Do not rely on color alone for meaning.
- Dialogs must have clear titles and actions.
- Forms should support numeric keyboards where appropriate.

## Content Guidelines

- Use simple fitness language.
- Avoid medical claims.
- Do not promise guaranteed results.
- Explain privacy controls plainly.
- Use action labels like "Log Progress", "Create My Plan", "Reset Profile".

## Navigation Guidelines

Current tab structure is acceptable for MVP:

- Dashboard.
- Workout.
- Diet.
- Profile.

Future tabs should not be added casually. If features grow, use nested pages inside existing sections before expanding the main navigation.

## UI Components To Standardize

- Primary button.
- Secondary button.
- Destructive button.
- Metric card.
- Section header.
- Exercise card.
- Meal card.
- Progress chart card.
- Form field.
- Consent/privacy card.
- Confirmation dialog.

## Current UI Gaps

- No reusable component system.
- No formal theme file.
- No profile editing UX.
- No data export/privacy screen.
- Limited progress metrics.
- No loading/error/empty state standards across all screens.
- App label and Android identity still need production branding.
