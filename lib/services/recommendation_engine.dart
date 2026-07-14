import '../models/user_profile.dart';
import '../models/workout.dart';

class RecommendationEngine {
  /// Generates a weekly workout plan based on user profile.
  static List<WorkoutPlan> generateWorkoutPlan(UserProfile profile) {
    final bmiCategory = profile.bmiCategory;
    final goal = profile.goal;
    final isBeginner = profile.activityLevel == 'sedentary';

    List<WorkoutPlan> plans = [];

    // Monday: Push
    plans.add(WorkoutPlan(
      day: 'Monday',
      focus: 'Chest & Triceps (Push)',
      workouts: _getPushWorkouts(bmiCategory, goal, isBeginner),
    ));

    // Tuesday: Pull
    plans.add(WorkoutPlan(
      day: 'Tuesday',
      focus: 'Back & Biceps (Pull)',
      workouts: _getPullWorkouts(bmiCategory, goal, isBeginner),
    ));

    // Wednesday: Legs
    plans.add(WorkoutPlan(
      day: 'Wednesday',
      focus: 'Legs & Glutes',
      workouts: _getLegWorkouts(bmiCategory, goal, isBeginner),
    ));

    // Thursday: Core & Cardio
    plans.add(WorkoutPlan(
      day: 'Thursday',
      focus: 'Core & Cardio',
      workouts: _getCoreWorkouts(bmiCategory, goal, isBeginner),
    ));

    // Friday: Full Body / Compound
    plans.add(WorkoutPlan(
      day: 'Friday',
      focus: 'Full Body Compound',
      workouts: _getFullBodyWorkouts(bmiCategory, goal, isBeginner),
    ));

    // Saturday: Active Recovery / Light Cardio
    plans.add(WorkoutPlan(
      day: 'Saturday',
      focus: 'Active Recovery',
      workouts: _getRecoveryWorkouts(bmiCategory, goal, isBeginner),
    ));

    // Sunday: Rest
    plans.add(WorkoutPlan(
      day: 'Sunday',
      focus: 'Rest & Recovery',
      workouts: [],
    ));

    return plans;
  }

  static List<Workout> _getPushWorkouts(
      String bmi, String goal, bool beginner) {
    int sets = beginner ? 3 : 4;
    int reps = _getReps(goal);

    return [
      Workout(
          name: 'Push-ups',
          category: 'push',
          sets: sets,
          reps: reps,
          restSeconds: 60,
          difficulty: bmi == 'obese' ? 'beginner' : 'intermediate'),
      Workout(
          name: 'Dumbbell Bench Press',
          category: 'push',
          sets: sets,
          reps: reps,
          restSeconds: 90,
          difficulty: 'intermediate'),
      Workout(
          name: 'Incline Dumbbell Press',
          category: 'push',
          sets: sets - 1,
          reps: reps,
          restSeconds: 60,
          difficulty: 'intermediate'),
      Workout(
          name: 'Tricep Dips',
          category: 'push',
          sets: sets - 1,
          reps: reps + 2,
          restSeconds: 45,
          difficulty: 'intermediate'),
      Workout(
          name: 'Lateral Raises',
          category: 'push',
          sets: 3,
          reps: 15,
          restSeconds: 45,
          difficulty: 'beginner'),
    ];
  }

  static List<Workout> _getPullWorkouts(
      String bmi, String goal, bool beginner) {
    int sets = beginner ? 3 : 4;
    int reps = _getReps(goal);

    return [
      Workout(
          name: 'Dumbbell Rows',
          category: 'pull',
          sets: sets,
          reps: reps,
          restSeconds: 90,
          difficulty: 'intermediate'),
      Workout(
          name: 'Lat Pulldowns (Resistance Band)',
          category: 'pull',
          sets: sets,
          reps: reps,
          restSeconds: 60,
          difficulty: 'intermediate'),
      Workout(
          name: 'Dumbbell Bicep Curls',
          category: 'pull',
          sets: sets - 1,
          reps: reps + 2,
          restSeconds: 45,
          difficulty: 'beginner'),
      Workout(
          name: 'Face Pulls',
          category: 'pull',
          sets: 3,
          reps: 15,
          restSeconds: 45,
          difficulty: 'beginner'),
    ];
  }

  static List<Workout> _getLegWorkouts(String bmi, String goal, bool beginner) {
    int sets = beginner ? 3 : 4;
    int reps = _getReps(goal);

    return [
      Workout(
          name: 'Bodyweight Squats',
          category: 'legs',
          sets: sets,
          reps: reps + 5,
          restSeconds: 60,
          difficulty: 'beginner'),
      Workout(
          name: 'Dumbbell Lunges',
          category: 'legs',
          sets: sets - 1,
          reps: reps,
          restSeconds: 60,
          difficulty: 'intermediate'),
      Workout(
          name: 'Glute Bridges',
          category: 'legs',
          sets: sets,
          reps: 15,
          restSeconds: 45,
          difficulty: 'beginner'),
      Workout(
          name: 'Calf Raises',
          category: 'legs',
          sets: 4,
          reps: 20,
          restSeconds: 30,
          difficulty: 'beginner'),
    ];
  }

  static List<Workout> _getCoreWorkouts(
      String bmi, String goal, bool beginner) {
    return [
      Workout(
          name: 'Plank',
          category: 'core',
          sets: 3,
          reps: 30, // seconds
          restSeconds: 30,
          difficulty: 'beginner'),
      Workout(
          name: 'Crunches',
          category: 'core',
          sets: 3,
          reps: beginner ? 12 : 20,
          restSeconds: 30,
          difficulty: 'beginner'),
      Workout(
          name: 'Russian Twists',
          category: 'core',
          sets: 3,
          reps: 16,
          restSeconds: 30,
          difficulty: 'intermediate'),
      Workout(
          name: 'Bicycle Crunches',
          category: 'core',
          sets: 3,
          reps: 20,
          restSeconds: 30,
          difficulty: 'intermediate'),
      Workout(
          name: 'Jumping Jacks (Cardio burst)',
          category: 'cardio',
          sets: 3,
          reps: 30, // seconds
          restSeconds: 15,
          difficulty: 'beginner'),
    ];
  }

  static List<Workout> _getFullBodyWorkouts(
      String bmi, String goal, bool beginner) {
    int sets = beginner ? 3 : 4;
    int reps = _getReps(goal);

    return [
      Workout(
          name: 'Dumbbell Goblet Squats',
          category: 'legs',
          sets: sets,
          reps: reps,
          restSeconds: 90,
          difficulty: 'intermediate'),
      Workout(
          name: 'Dumbbell Shoulder Press',
          category: 'push',
          sets: sets - 1,
          reps: reps,
          restSeconds: 60,
          difficulty: 'intermediate'),
      Workout(
          name: 'Bent Over Rows',
          category: 'pull',
          sets: sets - 1,
          reps: reps,
          restSeconds: 60,
          difficulty: 'intermediate'),
      Workout(
          name: 'Deadlifts (Dumbbell)',
          category: 'legs',
          sets: sets,
          reps: reps,
          restSeconds: 90,
          difficulty: 'intermediate'),
    ];
  }

  static List<Workout> _getRecoveryWorkouts(
      String bmi, String goal, bool beginner) {
    return [
      Workout(
          name: 'Walking',
          category: 'cardio',
          sets: 1,
          reps: 30, // minutes
          restSeconds: 0,
          difficulty: 'beginner'),
      Workout(
          name: 'Stretching (Full Body)',
          category: 'core',
          sets: 1,
          reps: 15, // minutes
          restSeconds: 0,
          difficulty: 'beginner'),
      Workout(
          name: 'Foam Rolling',
          category: 'core',
          sets: 1,
          reps: 10, // minutes
          restSeconds: 0,
          difficulty: 'beginner'),
    ];
  }

  static int _getReps(String goal) {
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

  /// Generates a diet plan based on user profile.
  static DietPlan generateDietPlan(UserProfile profile) {
    final bmiCategory = profile.bmiCategory;
    final goal = profile.goal;
    final activityLevel = profile.activityLevel;

    // Calculate BMR using Mifflin-St Jeor Equation
    double bmr;
    if (profile.gender == 'male') {
      bmr = 10 * profile.weight + 6.25 * profile.height - 5 * profile.age + 5;
    } else {
      bmr = 10 * profile.weight + 6.25 * profile.height - 5 * profile.age - 161;
    }

    // Activity multiplier
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

    double tdee = bmr * activityMultiplier;

    // Adjust calories based on goal
    double targetCalories;
    String notes;

    switch (goal) {
      case 'lose_weight':
        targetCalories = tdee - 500;
        notes =
            'Caloric deficit of 500 kcal/day. Focus on high protein, fiber-rich foods to stay full. Aim for 0.5-1kg weight loss per week.';
        break;
      case 'gain_muscle':
        targetCalories = tdee + 300;
        notes =
            'Caloric surplus for muscle growth. High protein intake (1.6-2.2g per kg bodyweight). Focus on compound movements.';
        break;
      case 'maintain':
      default:
        targetCalories = tdee;
        notes =
            'Maintenance calories. Balanced macros with emphasis on whole foods. Continue progressive overload in training.';
        break;
    }

    // Adjust for BMI
    if (bmiCategory == 'obese' && goal == 'lose_weight') {
      targetCalories = targetCalories.clamp(1500, 2200).toDouble();
      notes +=
          '\n\nGiven your BMI, a moderate deficit with emphasis on whole foods and regular cardio is recommended.';
    } else if (bmiCategory == 'underweight' && goal == 'gain_muscle') {
      targetCalories += 200;
      notes +=
          '\n\nGiven your BMI, increase caloric intake with nutrient-dense foods. Frequent meals are recommended.';
    }

    int dailyCalories = targetCalories.round();

    return DietPlan(
      dailyCalories: dailyCalories,
      meals: _generateMeals(dailyCalories, goal, profile),
      notes: notes,
    );
  }

  static List<Meal> _generateMeals(
      int dailyCalories, String goal, UserProfile profile) {
    final proteinTarget = (profile.weight * 1.8).round();

    // Distribute calories across meals
    final breakfastCal = (dailyCalories * 0.25).round();
    final lunchCal = (dailyCalories * 0.35).round();
    final dinnerCal = (dailyCalories * 0.25).round();
    final snackCal = (dailyCalories * 0.15).round();

    return [
      Meal(
        name: 'Breakfast',
        time: '7:00 AM - 8:00 AM',
        foods: _getBreakfastFoods(goal, profile.bmiCategory),
        calories: breakfastCal,
        macros:
            'P:${(proteinTarget * 0.3).round()}g C:${(breakfastCal * 0.5 / 4).round()}g F:${(breakfastCal * 0.2 / 9).round()}g',
      ),
      Meal(
        name: 'Lunch',
        time: '12:30 PM - 1:30 PM',
        foods: _getLunchFoods(goal, profile.bmiCategory),
        calories: lunchCal,
        macros:
            'P:${(proteinTarget * 0.35).round()}g C:${(lunchCal * 0.5 / 4).round()}g F:${(lunchCal * 0.2 / 9).round()}g',
      ),
      Meal(
        name: 'Snack',
        time: '4:00 PM - 5:00 PM',
        foods: _getSnackFoods(goal),
        calories: snackCal,
        macros:
            'P:${(proteinTarget * 0.15).round()}g C:${(snackCal * 0.4 / 4).round()}g F:${(snackCal * 0.3 / 9).round()}g',
      ),
      Meal(
        name: 'Dinner',
        time: '7:30 PM - 8:30 PM',
        foods: _getDinnerFoods(goal, profile.bmiCategory),
        calories: dinnerCal,
        macros:
            'P:${(proteinTarget * 0.2).round()}g C:${(dinnerCal * 0.4 / 4).round()}g F:${(dinnerCal * 0.3 / 9).round()}g',
      ),
    ];
  }

  static List<String> _getBreakfastFoods(String goal, String bmiCategory) {
    if (goal == 'lose_weight') {
      return [
        '2 scrambled eggs',
        '1 slice whole grain toast',
        '1/2 avocado',
        'Black coffee or green tea',
      ];
    } else if (goal == 'gain_muscle') {
      return [
        '3-4 egg whites + 1 whole egg omelette',
        '1 cup oats with whey protein',
        '1 banana',
        '1 tbsp peanut butter',
      ];
    }
    return [
      '2 boiled eggs',
      '1 bowl oatmeal with fruits',
      '1 glass milk',
    ];
  }

  static List<String> _getLunchFoods(String goal, String bmiCategory) {
    if (goal == 'lose_weight') {
      return [
        '150g grilled chicken breast',
        '1 cup brown rice',
        'Steamed vegetables (broccoli, carrots)',
        'Green salad with lemon dressing',
      ];
    } else if (goal == 'gain_muscle') {
      return [
        '200g chicken or fish',
        '1.5 cup rice',
        'Mixed vegetables',
        '1 cup dal or lentils',
      ];
    }
    return [
      '150g lean protein (chicken/fish/tofu)',
      '1 cup quinoa or rice',
      'Roasted vegetables',
      'Yogurt',
    ];
  }

  static List<String> _getSnackFoods(String goal) {
    if (goal == 'lose_weight') {
      return [
        '1 apple or pear',
        '10 almonds',
        'Green tea',
      ];
    } else if (goal == 'gain_muscle') {
      return [
        'Protein shake (whey + milk)',
        '1 tbsp peanut butter',
        '1 banana',
      ];
    }
    return [
      'Mixed nuts (20g)',
      '1 fruit',
      'Buttermilk',
    ];
  }

  static List<String> _getDinnerFoods(String goal, String bmiCategory) {
    if (goal == 'lose_weight') {
      return [
        '150g grilled fish or paneer',
        'Large salad with chickpeas',
        '1 cup soup (clear broth)',
      ];
    } else if (goal == 'gain_muscle') {
      return [
        '200g red meat or fish',
        'Sweet potato (1 medium)',
        'Green vegetables',
        'Cottage cheese (before bed)',
      ];
    }
    return [
      '150g protein source',
      '1 cup vegetables',
      'Salad',
      '1 chapati or tortilla',
    ];
  }

  /// Get motivational tips based on BMI category.
  static String getMotivationalTip(String bmiCategory) {
    switch (bmiCategory) {
      case 'underweight':
        return 'Focus on nutrient-dense foods and progressive overload. Your goal is to build strength and mass steadily.';
      case 'normal':
        return 'Great work maintaining a healthy BMI! Focus on body recomposition and performance goals.';
      case 'overweight':
        return 'Every workout counts. Consistency beats intensity. Focus on sustainable habits and you will see results.';
      case 'obese':
        return 'Small steps lead to big changes. Start with walking and basic movements. Your journey is a marathon, not a sprint.';
      default:
        return 'Stay consistent and trust the process!';
    }
  }

  /// Get water intake recommendation.
  static double getRecommendedWaterIntake(UserProfile profile) {
    double baseLiters = profile.weight * 0.033;
    if (profile.activityLevel == 'active' ||
        profile.activityLevel == 'very_active') {
      baseLiters += 0.5;
    }
    return (baseLiters * 10).round() / 10;
  }
}
