import 'package:uuid/uuid.dart';

import '../data/exercise_library.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../models/workout_session.dart';

class ExerciseWorkoutMapper {
  static Workout fromExercise({
    required Exercise exercise,
    required int sets,
    required int reps,
    required int restSeconds,
  }) {
    return Workout(
      exerciseId: exercise.id,
      name: exercise.name,
      category: exercise.category.toLowerCase(),
      sets: sets,
      reps: reps,
      restSeconds: restSeconds,
      difficulty: exercise.difficulty.toLowerCase(),
      description: exercise.instructions.join(' '),
      demoUrl: exercise.demoUrl,
    );
  }

  static Exercise? exerciseForWorkout(Workout workout) {
    return ExerciseLibrary.findById(workout.exerciseId);
  }
}

class WorkoutSessionService {
  final Uuid _uuid = const Uuid();

  WorkoutSession createSession(WorkoutPlan plan) {
    return WorkoutSession(
      sessionId: _uuid.v4(),
      workoutDay: plan.day,
      startedAt: DateTime.now(),
      exercises: [
        for (final workout in plan.workouts)
          WorkoutExerciseProgress(
            exerciseId: workout.exerciseId,
            totalSets: workout.sets,
          ),
      ],
    );
  }

  void completeSet(WorkoutSession session, int exerciseIndex) {
    if (exerciseIndex < 0 || exerciseIndex >= session.exercises.length) {
      return;
    }

    final exercise = session.exercises[exerciseIndex];

    if (exercise.isCompleted) {
      return;
    }

    exercise.completeSet();

    if (session.isCompleted) {
      session.markCompleted();
    }
  }

  bool isExerciseCompleted(WorkoutSession session, int exerciseIndex) {
    if (exerciseIndex < 0 || exerciseIndex >= session.exercises.length) {
      return false;
    }

    return session.exercises[exerciseIndex].isCompleted;
  }

  double exerciseProgress(WorkoutSession session, int exerciseIndex) {
    if (exerciseIndex < 0 || exerciseIndex >= session.exercises.length) {
      return 0;
    }

    return session.exercises[exerciseIndex].progress;
  }
}
