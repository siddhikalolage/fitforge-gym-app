import '../models/exercise.dart';

class ExerciseLibrary {
  static const List<Exercise> exercises = [
    Exercise(
      id: 'push_up',
      name: 'Push-Up',
      category: 'Chest',
      muscleGroup: 'Chest, Triceps, Shoulders',
      equipment: 'None',
      difficulty: 'Beginner',
      goals: ['lose_weight', 'maintain', 'gain_muscle'],
      instructions: [
        'Start in a high plank position.',
        'Keep your body straight from head to heels.',
        'Lower your chest toward the floor.',
        'Push through your hands to return to the starting position.',
      ],
      commonMistakes: [
        'Letting the hips sag.',
        'Flaring the elbows too far outward.',
        'Not using a full range of motion.',
      ],
      demoUrl: null,
      alternativeExercises: ['incline_push_up', 'knee_push_up'],
    ),

    Exercise(
      id: 'bodyweight_squat',
      name: 'Bodyweight Squat',
      category: 'Legs',
      muscleGroup: 'Quadriceps, Glutes, Hamstrings',
      equipment: 'None',
      difficulty: 'Beginner',
      goals: ['lose_weight', 'maintain', 'gain_muscle'],
      instructions: [
        'Stand with your feet approximately shoulder-width apart.',
        'Push your hips backward and bend your knees.',
        'Lower your body while keeping your chest upright.',
        'Drive through your feet to return to standing.',
      ],
      commonMistakes: [
        'Knees collapsing inward.',
        'Rounding the back.',
        'Lifting the heels from the floor.',
      ],
      demoUrl: null,
      alternativeExercises: ['goblet_squat', 'leg_press'],
    ),

    Exercise(
      id: 'dumbbell_bench_press',
      name: 'Dumbbell Bench Press',
      category: 'Chest',
      muscleGroup: 'Chest, Triceps, Shoulders',
      equipment: 'Dumbbells + Bench',
      difficulty: 'Intermediate',
      goals: ['maintain', 'gain_muscle'],
      instructions: [
        'Lie on a bench with a dumbbell in each hand.',
        'Position the dumbbells beside your chest.',
        'Press the dumbbells upward.',
        'Lower them under control and repeat.',
      ],
      commonMistakes: [
        'Using excessive weight.',
        'Dropping the dumbbells too quickly.',
        'Lifting the hips from the bench.',
      ],
      demoUrl: null,
      alternativeExercises: ['push_up', 'machine_chest_press'],
    ),

    Exercise(
      id: 'dumbbell_row',
      name: 'Dumbbell Row',
      category: 'Back',
      muscleGroup: 'Lats, Rhomboids, Biceps',
      equipment: 'Dumbbell',
      difficulty: 'Beginner',
      goals: ['maintain', 'gain_muscle'],
      instructions: [
        'Place one hand on a stable surface.',
        'Keep your back neutral.',
        'Pull the dumbbell toward your hip.',
        'Lower the dumbbell slowly.',
      ],
      commonMistakes: [
        'Rounding the back.',
        'Using momentum.',
        'Shrugging the shoulder.',
      ],
      demoUrl: null,
      alternativeExercises: ['resistance_band_row', 'lat_pulldown'],
    ),

    Exercise(
      id: 'glute_bridge',
      name: 'Glute Bridge',
      category: 'Glutes',
      muscleGroup: 'Glutes, Hamstrings',
      equipment: 'None',
      difficulty: 'Beginner',
      goals: ['lose_weight', 'maintain', 'gain_muscle'],
      instructions: [
        'Lie on your back with your knees bent.',
        'Keep your feet flat on the floor.',
        'Drive through your feet and lift your hips.',
        'Squeeze your glutes at the top.',
        'Lower your hips slowly.',
      ],
      commonMistakes: [
        'Overarching the lower back.',
        'Pushing mainly through the toes.',
        'Moving too quickly.',
      ],
      demoUrl: null,
      alternativeExercises: ['hip_thrust', 'bodyweight_squat'],
    ),

    Exercise(
      id: 'plank',
      name: 'Plank',
      category: 'Core',
      muscleGroup: 'Abdominals, Core, Shoulders',
      equipment: 'None',
      difficulty: 'Beginner',
      goals: ['lose_weight', 'maintain', 'gain_muscle'],
      instructions: [
        'Place your forearms on the floor.',
        'Extend your legs behind you.',
        'Keep your body in a straight line.',
        'Brace your core and hold the position.',
      ],
      commonMistakes: [
        'Dropping the hips.',
        'Raising the hips too high.',
        'Holding your breath.',
      ],
      demoUrl: null,
      alternativeExercises: ['dead_bug', 'knee_plank'],
    ),

    Exercise(
      id: 'walking',
      name: 'Walking',
      category: 'Cardio',
      muscleGroup: 'Full Body',
      equipment: 'None',
      difficulty: 'Beginner',
      goals: ['lose_weight', 'maintain'],
      instructions: [
        'Maintain an upright posture.',
        'Walk at a comfortable pace.',
        'Keep your arms moving naturally.',
        'Gradually increase duration or pace as fitness improves.',
      ],
      commonMistakes: [
        'Starting too aggressively.',
        'Poor posture.',
        'Ignoring pain or discomfort.',
      ],
      demoUrl: null,
      alternativeExercises: ['cycling', 'elliptical'],
    ),
  ];

  static Exercise? findById(String id) {
    for (final exercise in exercises) {
      if (exercise.id == id) {
        return exercise;
      }
    }
    return null;
  }

  static List<Exercise> forGoal(String goal) {
    return exercises
        .where((exercise) => exercise.goals.contains(goal))
        .toList();
  }

  static List<Exercise> byCategory(String category) {
    return exercises
        .where(
          (exercise) =>
              exercise.category.toLowerCase() == category.toLowerCase(),
        )
        .toList();
  }
}
