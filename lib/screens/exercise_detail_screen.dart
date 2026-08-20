import 'package:flutter/material.dart';
import '../models/exercise.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: exercise.demoUrl != null
                ? Center(
                    child: Text(
                      'Exercise demo',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 64,
                        color: Colors.orangeAccent,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Demo coming soon',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: 24),

          Text(
            exercise.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _infoChip(context, Icons.accessibility_new, exercise.muscleGroup),
              _infoChip(context, Icons.fitness_center, exercise.equipment),
              _infoChip(
                context,
                Icons.signal_cellular_alt,
                exercise.difficulty,
              ),
            ],
          ),

          const SizedBox(height: 28),

          Text(
            'How to perform',
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          const SizedBox(height: 12),

          ...exercise.instructions.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final instruction = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.orangeAccent.withValues(
                      alpha: 0.15,
                    ),
                    child: Text(
                      '$index',
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      instruction,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),

          Text(
            'Common mistakes',
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          const SizedBox(height: 12),

          ...exercise.commonMistakes.map(
            (mistake) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orangeAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      mistake,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.orangeAccent),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}
