class WorkoutExerciseProgress {
  final String exerciseId;
  final int totalSets;
  int completedSets;

  WorkoutExerciseProgress({
    required this.exerciseId,
    required this.totalSets,
    this.completedSets = 0,
  });

  bool get isCompleted => completedSets >= totalSets;

  double get progress {
    if (totalSets == 0) return 1.0;
    return completedSets / totalSets;
  }

  void completeSet() {
    if (completedSets < totalSets) {
      completedSets++;
    }
  }
}

class WorkoutSession {
  final String sessionId;
  final String workoutDay;
  final DateTime startedAt;
  DateTime? completedAt;

  final List<WorkoutExerciseProgress> exercises;

  WorkoutSession({
    required this.sessionId,
    required this.workoutDay,
    required this.startedAt,
    required this.exercises,
    this.completedAt,
  });

  bool get isCompleted => exercises.every((exercise) => exercise.isCompleted);

  int get totalSets {
    return exercises.fold(0, (total, exercise) => total + exercise.totalSets);
  }

  int get completedSets {
    return exercises.fold(
      0,
      (total, exercise) => total + exercise.completedSets,
    );
  }

  double get progress {
    if (totalSets == 0) return 0;
    return completedSets / totalSets;
  }

  void markCompleted() {
    if (isCompleted) {
      completedAt = DateTime.now();
    }
  }
}
