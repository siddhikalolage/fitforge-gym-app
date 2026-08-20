class Workout {
  final String exerciseId;
  final String name;
  final String category;
  final int sets;
  final int reps;
  final int restSeconds;
  final String difficulty;
  final String description;
  final String? demoUrl;

  const Workout({
    required this.exerciseId,
    required this.name,
    required this.category,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    required this.difficulty,
    required this.description,
    this.demoUrl,
  });
}

class WorkoutPlan {
  final String day;
  final List<Workout> workouts;
  final String focus;

  const WorkoutPlan({
    required this.day,
    required this.workouts,
    required this.focus,
  });
}

class Meal {
  final String name;
  final String time;
  final List<String> foods;
  final int calories;
  final String macros;

  const Meal({
    required this.name,
    required this.time,
    required this.foods,
    required this.calories,
    required this.macros,
  });
}

class DietPlan {
  final int dailyCalories;
  final List<Meal> meals;
  final String notes;

  const DietPlan({
    required this.dailyCalories,
    required this.meals,
    required this.notes,
  });
}

class DailyTask {
  final bool workoutCompleted;
  final bool dietFollowed;
  final double? waterIntake;
  final int? steps;
  final String? notes;

  const DailyTask({
    this.workoutCompleted = false,
    this.dietFollowed = false,
    this.waterIntake,
    this.steps,
    this.notes,
  });
}