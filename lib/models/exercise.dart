class Exercise {
  final String id;
  final String name;
  final String category;
  final String muscleGroup;
  final String equipment;
  final String difficulty;
  final List<String> goals;
  final List<String> instructions;
  final List<String> commonMistakes;
  final String? demoUrl;
  final List<String> alternativeExercises;

  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.muscleGroup,
    required this.equipment,
    required this.difficulty,
    required this.goals,
    required this.instructions,
    required this.commonMistakes,
    this.demoUrl,
    required this.alternativeExercises,
  });
}
