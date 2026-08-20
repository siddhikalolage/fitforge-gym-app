import '../data/exercise_library.dart';
import '../models/exercise.dart';
import '../models/user_profile.dart';
import '../models/workout.dart';

class RecommendationEngine {
  /// Generates a personalized weekly workout plan.
  ///
  /// Exercise selection is based on:
  /// - Member goal
  /// - Activity/experience level
  /// - BMI category
  ///
  /// Exercise details come from ExerciseLibrary.
  /// Workout-specific values such as sets, reps and rest are
  /// generated for the member.
  static List<WorkoutPlan> generateWorkoutPlan(UserProfile profile) {
    final exercises = _selectExercises(profile);

    return [
      WorkoutPlan(
        day: 'Monday',
        focus: 'Chest & Triceps',
        workouts: _buildWorkouts(
          exercises.where((e) => e.category == 'Chest').toList(),
          profile,
        ),
      ),
      WorkoutPlan(
        day: 'Tuesday',
        focus: 'Back & Biceps',
        workouts: _buildWorkouts(
          exercises.where((e) => e.category == 'Back').toList(),
          profile,
        ),
      ),
      WorkoutPlan(
        day: 'Wednesday',
        focus: 'Legs & Glutes',
        workouts: _buildWorkouts(
          exercises
              .where((e) => e.category == 'Legs' || e.category == 'Glutes')
              .toList(),
          profile,
        ),
      ),
      WorkoutPlan(
        day: 'Thursday',
        focus: 'Core & Cardio',
        workouts: _buildWorkouts(
          exercises
              .where((e) => e.category == 'Core' || e.category == 'Cardio')
              .toList(),
          profile,
        ),
      ),
      WorkoutPlan(
        day: 'Friday',
        focus: 'Full Body',
        workouts: _buildWorkouts(exercises, profile, limit: 5),
      ),
      WorkoutPlan(
        day: 'Saturday',
        focus: 'Active Recovery',
        workouts: _buildRecoveryWorkout(profile),
      ),
      WorkoutPlan(day: 'Sunday', focus: 'Rest & Recovery', workouts: const []),
    ];
  }

  // ---------------------------------------------------------------------------
  // EXERCISE SELECTION
  // ---------------------------------------------------------------------------

  /// Selects exercises according to the member's goal,
  /// experience level and BMI category.
  static List<Exercise> _selectExercises(UserProfile profile) {
    final goalExercises = ExerciseLibrary.forGoal(profile.goal);

    if (goalExercises.isEmpty) {
      return ExerciseLibrary.exercises;
    }

    final isBeginner = profile.activityLevel == 'sedentary';

    final filtered = goalExercises.where((exercise) {
      // Beginners should not receive advanced exercises.
      if (isBeginner && exercise.difficulty == 'Advanced') {
        return false;
      }

      // Higher-BMI members should initially avoid demanding cardio.
      if (profile.bmiCategory == 'obese') {
        if (exercise.category == 'Cardio' &&
            exercise.difficulty != 'Beginner') {
          return false;
        }
      }

      return true;
    }).toList();

    return filtered.isEmpty ? goalExercises : filtered;
  }

  // ---------------------------------------------------------------------------
  // WORKOUT CREATION
  // ---------------------------------------------------------------------------

  /// Converts Exercise objects from the exercise library into
  /// member-specific Workout objects.
  static List<Workout> _buildWorkouts(
    List<Exercise> exercises,
    UserProfile profile, {
    int limit = 4,
  }) {
    final selected = exercises.take(limit).toList();

    return selected.map((exercise) {
      final sets = _getSets(profile);
      final reps = _getReps(profile.goal, exercise);
      final rest = _getRestSeconds(exercise);

      return Workout(
        // Important:
        // Keeps the connection between Workout and Exercise Library.
        exerciseId: exercise.id,

        name: exercise.name,
        category: exercise.category.toLowerCase(),
        sets: sets,
        reps: reps,
        restSeconds: rest,
        difficulty: exercise.difficulty.toLowerCase(),
        description: _buildDescription(exercise),
        demoUrl: exercise.demoUrl,
      );
    }).toList();
  }

  /// Creates the Saturday recovery workout.
  static List<Workout> _buildRecoveryWorkout(UserProfile profile) {
    final recoveryExercises = ExerciseLibrary.exercises
        .where(
          (exercise) =>
              exercise.category == 'Cardio' || exercise.category == 'Core',
        )
        .where((exercise) => exercise.difficulty == 'Beginner')
        .take(2)
        .toList();

    return recoveryExercises.map((exercise) {
      return Workout(
        exerciseId: exercise.id,
        name: exercise.name,
        category: exercise.category.toLowerCase(),
        sets: 1,
        reps: exercise.name == 'Walking' ? 30 : 15,
        restSeconds: 30,
        difficulty: 'beginner',
        description: _buildDescription(exercise),
        demoUrl: exercise.demoUrl,
      );
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // TRAINING PARAMETERS
  // ---------------------------------------------------------------------------

  static int _getSets(UserProfile profile) {
    switch (profile.activityLevel) {
      case 'sedentary':
        return 2;

      case 'light':
        return 3;

      case 'moderate':
      case 'active':
      case 'very_active':
        return 3;

      default:
        return 3;
    }
  }

  static int _getReps(String goal, Exercise exercise) {
    // Plank uses seconds rather than repetitions.
    if (exercise.id == 'plank') {
      return 30;
    }

    switch (goal) {
      case 'gain_muscle':
        return 10;

      case 'lose_weight':
        return 15;

      case 'maintain':
      default:
        return 12;
    }
  }

  static int _getRestSeconds(Exercise exercise) {
    switch (exercise.difficulty) {
      case 'Advanced':
        return 90;

      case 'Intermediate':
        return 75;

      case 'Beginner':
      default:
        return 60;
    }
  }

  static String _buildDescription(Exercise exercise) {
    if (exercise.instructions.isEmpty) {
      return '${exercise.name} targets ${exercise.muscleGroup}.';
    }

    return exercise.instructions.join(' ');
  }

  // ---------------------------------------------------------------------------
  // DIET PLAN
  // ---------------------------------------------------------------------------

  /// Generates a personalized diet plan based on the member profile.
  static DietPlan generateDietPlan(UserProfile profile) {
    final goal = profile.goal;
    final activityLevel = profile.activityLevel;

    // Mifflin-St Jeor equation.
    double bmr;

    if (profile.gender == 'male') {
      bmr = 10 * profile.weight + 6.25 * profile.height - 5 * profile.age + 5;
    } else {
      bmr = 10 * profile.weight + 6.25 * profile.height - 5 * profile.age - 161;
    }

    // Activity multiplier.
    double activityMultiplier;

    switch (activityLevel) {
      case 'sedentary':
        activityMultiplier = 1.2;
        break;

      case 'light':
        activityMultiplier = 1.375;
        break;

      case 'moderate':
        activityMultiplier = 1.55;
        break;

      case 'active':
        activityMultiplier = 1.725;
        break;

      case 'very_active':
        activityMultiplier = 1.9;
        break;

      default:
        activityMultiplier = 1.2;
    }

    final tdee = bmr * activityMultiplier;

    double targetCalories;
    String notes;

    switch (goal) {
      case 'lose_weight':
        targetCalories = tdee - 500;
        notes =
            'Caloric deficit of approximately 500 kcal/day. '
            'Focus on protein, vegetables, whole grains and high-fiber foods.';
        break;

      case 'gain_muscle':
        targetCalories = tdee + 300;
        notes =
            'Small caloric surplus with adequate protein and progressive '
            'resistance training is recommended.';
        break;

      case 'maintain':
      default:
        targetCalories = tdee;
        notes =
            'Maintenance calories with balanced nutrition and consistent '
            'training.';
        break;
    }

    // BMI-specific adjustments.
    if (profile.bmiCategory == 'obese' && goal == 'lose_weight') {
      targetCalories = targetCalories.clamp(1500, 2200).toDouble();

      notes +=
          '\n\nStart gradually and prioritize sustainable activity and recovery.';
    } else if (profile.bmiCategory == 'underweight' && goal == 'gain_muscle') {
      targetCalories += 200;

      notes +=
          '\n\nPrioritize nutrient-dense foods and adequate protein intake.';
    }

    final dailyCalories = targetCalories.round();

    return DietPlan(
      dailyCalories: dailyCalories,
      meals: _generateMeals(dailyCalories, goal, profile),
      notes: notes,
    );
  }

  // ---------------------------------------------------------------------------
  // MEAL GENERATION
  // ---------------------------------------------------------------------------

  static List<Meal> _generateMeals(
    int dailyCalories,
    String goal,
    UserProfile profile,
  ) {
    final proteinTarget = (profile.weight * 1.8).round();

    final breakfastCal = (dailyCalories * 0.25).round();
    final lunchCal = (dailyCalories * 0.35).round();
    final dinnerCal = (dailyCalories * 0.25).round();
    final snackCal = (dailyCalories * 0.15).round();

    return [
      Meal(
        name: 'Breakfast',
        time: '7:00 AM - 8:00 AM',
        foods: _getBreakfastFoods(goal),
        calories: breakfastCal,
        macros:
            'P:${(proteinTarget * 0.3).round()}g '
            'C:${(breakfastCal * 0.5 / 4).round()}g '
            'F:${(breakfastCal * 0.2 / 9).round()}g',
      ),
      Meal(
        name: 'Lunch',
        time: '12:30 PM - 1:30 PM',
        foods: _getLunchFoods(goal),
        calories: lunchCal,
        macros:
            'P:${(proteinTarget * 0.35).round()}g '
            'C:${(lunchCal * 0.5 / 4).round()}g '
            'F:${(lunchCal * 0.2 / 9).round()}g',
      ),
      Meal(
        name: 'Snack',
        time: '4:00 PM - 5:00 PM',
        foods: _getSnackFoods(goal),
        calories: snackCal,
        macros:
            'P:${(proteinTarget * 0.15).round()}g '
            'C:${(snackCal * 0.4 / 4).round()}g '
            'F:${(snackCal * 0.3 / 9).round()}g',
      ),
      Meal(
        name: 'Dinner',
        time: '7:30 PM - 8:30 PM',
        foods: _getDinnerFoods(goal),
        calories: dinnerCal,
        macros:
            'P:${(proteinTarget * 0.2).round()}g '
            'C:${(dinnerCal * 0.4 / 4).round()}g '
            'F:${(dinnerCal * 0.3 / 9).round()}g',
      ),
    ];
  }

  static List<String> _getBreakfastFoods(String goal) {
    switch (goal) {
      case 'lose_weight':
        return [
          '2 scrambled eggs',
          '1 slice whole grain toast',
          '1/2 avocado',
          'Black coffee or green tea',
        ];

      case 'gain_muscle':
        return [
          'Egg omelette',
          'Oats with milk and protein source',
          '1 banana',
          '1 tbsp peanut butter',
        ];

      default:
        return ['2 boiled eggs', 'Oatmeal with fruit', '1 glass milk'];
    }
  }

  static List<String> _getLunchFoods(String goal) {
    switch (goal) {
      case 'lose_weight':
        return [
          'Lean protein',
          'Brown rice',
          'Steamed vegetables',
          'Green salad',
        ];

      case 'gain_muscle':
        return [
          'Chicken, fish, paneer or tofu',
          'Rice',
          'Mixed vegetables',
          'Dal or lentils',
        ];

      default:
        return [
          'Lean protein source',
          'Rice or quinoa',
          'Roasted vegetables',
          'Yogurt',
        ];
    }
  }

  static List<String> _getSnackFoods(String goal) {
    switch (goal) {
      case 'lose_weight':
        return ['1 fruit', '10 almonds', 'Green tea'];

      case 'gain_muscle':
        return ['Protein shake', 'Peanut butter', '1 banana'];

      default:
        return ['Mixed nuts', '1 fruit', 'Buttermilk'];
    }
  }

  static List<String> _getDinnerFoods(String goal) {
    switch (goal) {
      case 'lose_weight':
        return ['Lean protein', 'Large salad', 'Vegetable soup'];

      case 'gain_muscle':
        return [
          'Protein source',
          'Sweet potato or rice',
          'Green vegetables',
          'Cottage cheese',
        ];

      default:
        return [
          'Protein source',
          'Vegetables',
          'Salad',
          '1 chapati or tortilla',
        ];
    }
  }

  // ---------------------------------------------------------------------------
  // ADDITIONAL RECOMMENDATIONS
  // ---------------------------------------------------------------------------

  static String getMotivationalTip(String bmiCategory) {
    switch (bmiCategory) {
      case 'underweight':
        return 'Focus on nutrient-dense foods and progressive strength training.';

      case 'normal':
        return 'Focus on consistency, performance and progressive improvement.';

      case 'overweight':
        return 'Consistency beats intensity. Build sustainable habits.';

      case 'obese':
        return 'Start with manageable movements and gradually increase activity.';

      default:
        return 'Stay consistent and trust the process!';
    }
  }

  static double getRecommendedWaterIntake(UserProfile profile) {
    double baseLiters = profile.weight * 0.033;

    if (profile.activityLevel == 'active' ||
        profile.activityLevel == 'very_active') {
      baseLiters += 0.5;
    }

    return (baseLiters * 10).round() / 10;
  }
}
