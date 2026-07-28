# FitForge AI Backend Schema

## Purpose

This document defines a future backend data model for FitForge AI. The current MVP is local-first and does not yet require a backend, but new features should align with this model to avoid rework.

## Database Choice

Recommended primary database: PostgreSQL.

Recommended supporting services:

- Redis for sessions, caching, queues, and rate limiting.
- Object storage for profile images, exercise media, and uploaded progress media.
- Analytics warehouse later if usage grows.

## Roles

```text
user
trainer
owner
admin
```

## Core Tables

### users

Stores identity-level account data.

```text
id uuid primary key
email text unique not null
phone text unique nullable
password_hash text nullable
auth_provider text not null
role text not null
status text not null
created_at timestamptz not null
updated_at timestamptz not null
last_login_at timestamptz nullable
```

### user_profiles

Stores health and personalization data.

```text
id uuid primary key
user_id uuid references users(id)
name text not null
age integer not null
gender text not null
height_cm numeric not null
weight_kg numeric not null
activity_level text not null
goal text not null
experience_level text nullable
food_preference text nullable
region text nullable
created_at timestamptz not null
updated_at timestamptz not null
```

### gyms

Stores gym organization data.

```text
id uuid primary key
owner_id uuid references users(id)
name text not null
address text nullable
city text nullable
country text nullable
status text not null
created_at timestamptz not null
updated_at timestamptz not null
```

### gym_memberships

Links users to gyms.

```text
id uuid primary key
gym_id uuid references gyms(id)
user_id uuid references users(id)
membership_status text not null
start_date date nullable
end_date date nullable
created_at timestamptz not null
updated_at timestamptz not null
```

### trainer_clients

Links trainers to clients.

```text
id uuid primary key
trainer_id uuid references users(id)
client_id uuid references users(id)
status text not null
created_at timestamptz not null
updated_at timestamptz not null
```

## Fitness Tables

### workout_plans

```text
id uuid primary key
user_id uuid references users(id)
created_by_user_id uuid references users(id) nullable
source text not null
goal text not null
plan_json jsonb not null
schema_version integer not null
status text not null
created_at timestamptz not null
updated_at timestamptz not null
```

### workout_logs

```text
id uuid primary key
user_id uuid references users(id)
workout_plan_id uuid references workout_plans(id) nullable
performed_at timestamptz not null
duration_minutes integer nullable
intensity integer nullable
notes text nullable
created_at timestamptz not null
```

### exercise_logs

```text
id uuid primary key
workout_log_id uuid references workout_logs(id)
exercise_name text not null
sets integer nullable
reps integer nullable
weight_kg numeric nullable
duration_seconds integer nullable
created_at timestamptz not null
```

### nutrition_plans

```text
id uuid primary key
user_id uuid references users(id)
source text not null
daily_calories integer not null
plan_json jsonb not null
schema_version integer not null
status text not null
created_at timestamptz not null
updated_at timestamptz not null
```

### nutrition_logs

```text
id uuid primary key
user_id uuid references users(id)
logged_date date not null
calories integer nullable
protein_g numeric nullable
carbs_g numeric nullable
fat_g numeric nullable
water_liters numeric nullable
compliance_score integer nullable
notes text nullable
created_at timestamptz not null
```

### progress_entries

```text
id uuid primary key
user_id uuid references users(id)
entry_date date not null
weight_kg numeric nullable
bmi numeric nullable
body_fat_percent numeric nullable
muscle_mass_kg numeric nullable
waist_cm numeric nullable
sleep_hours numeric nullable
steps integer nullable
created_at timestamptz not null
updated_at timestamptz not null
unique(user_id, entry_date)
```

### recovery_scores

```text
id uuid primary key
user_id uuid references users(id)
score_date date not null
recovery_score integer not null
fatigue_level integer nullable
readiness_score integer nullable
sleep_quality integer nullable
recommendation_json jsonb nullable
created_at timestamptz not null
```

## AI Tables

### ai_requests

```text
id uuid primary key
user_id uuid references users(id)
request_type text not null
provider text not null
input_hash text not null
status text not null
created_at timestamptz not null
completed_at timestamptz nullable
```

### ai_outputs

```text
id uuid primary key
ai_request_id uuid references ai_requests(id)
output_type text not null
output_json jsonb not null
schema_version integer not null
validation_status text not null
created_at timestamptz not null
```

## Security And Audit Tables

### audit_logs

```text
id uuid primary key
actor_user_id uuid references users(id) nullable
event_type text not null
target_type text nullable
target_id uuid nullable
metadata jsonb nullable
ip_address inet nullable
user_agent text nullable
created_at timestamptz not null
```

### refresh_tokens

```text
id uuid primary key
user_id uuid references users(id)
token_hash text not null
expires_at timestamptz not null
revoked_at timestamptz nullable
created_at timestamptz not null
```

## Indexing Requirements

- Index all foreign keys.
- Index progress_entries(user_id, entry_date).
- Index workout_logs(user_id, performed_at).
- Index nutrition_logs(user_id, logged_date).
- Index audit_logs(actor_user_id, created_at).
- Use pagination for user history and analytics endpoints.

## Privacy Requirements

- Store only data required for product behavior.
- Encrypt sensitive data in transit and at rest.
- Support account deletion and data export.
- Avoid storing raw AI prompts when hashed or summarized inputs are enough.
- Keep audit logs for sensitive account and role changes.
