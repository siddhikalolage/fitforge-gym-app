import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../models/workout.dart';
import '../services/recommendation_engine.dart';
import 'workout_screen.dart';

class WorkoutPlanScreen extends StatefulWidget {
  final UserProfile profile;

  const WorkoutPlanScreen({super.key, required this.profile});

  @override
  State<WorkoutPlanScreen> createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  late final List<WorkoutPlan> _plans;

  int _selectedDay = DateTime.now().weekday - 1;

  @override
  void initState() {
    super.initState();

    _plans = RecommendationEngine.generateWorkoutPlan(widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    final plan = _plans[_selectedDay];

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Plan')),
      body: Column(
        children: [
          _buildDaySelector(),

          Expanded(child: _buildPlan(plan)),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _plans.length,
        itemBuilder: (context, index) {
          final plan = _plans[index];
          final selected = index == _selectedDay;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = index;
              });
            },
            child: Container(
              width: 78,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.orangeAccent.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? Colors.orangeAccent : Colors.white12,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    plan.day.substring(0, 3),
                    style: TextStyle(
                      color: selected ? Colors.orangeAccent : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    plan.workouts.isEmpty
                        ? Icons.bedtime
                        : Icons.fitness_center,
                    color: plan.workouts.isEmpty
                        ? Colors.blueAccent
                        : Colors.orangeAccent,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlan(WorkoutPlan plan) {
    if (plan.workouts.isEmpty) {
      return _buildRestDay();
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(plan.focus, style: Theme.of(context).textTheme.headlineMedium),

        const SizedBox(height: 8),

        Text(
          '${plan.workouts.length} exercises',
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const SizedBox(height: 24),

        ...List.generate(plan.workouts.length, (index) {
          final workout = plan.workouts[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: Colors.orangeAccent.withValues(alpha: 0.15),
                child: const Icon(
                  Icons.fitness_center,
                  color: Colors.orangeAccent,
                ),
              ),
              title: Text(
                workout.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('${workout.sets} sets × ${workout.reps} reps'),
            ),
          );
        }),

        const SizedBox(height: 12),

        SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WorkoutSessionScreen(plan: plan),
                ),
              );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Workout', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildRestDay() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bedtime, size: 80, color: Colors.blue[300]),
            const SizedBox(height: 20),
            Text(
              'Rest & Recovery',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: Colors.blue[300]),
            ),
            const SizedBox(height: 12),
            const Text(
              'Recovery is an important part of your training.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
