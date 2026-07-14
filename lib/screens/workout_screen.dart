import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/workout.dart';
import '../services/recommendation_engine.dart';

class WorkoutScreen extends StatefulWidget {
  final UserProfile profile;

  const WorkoutScreen({super.key, required this.profile});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late List<WorkoutPlan> _plans;
  int _selectedDay = DateTime.now().weekday - 1; // 0 = Monday

  @override
  void initState() {
    super.initState();
    _plans = RecommendationEngine.generateWorkoutPlan(widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    final todayPlan =
        _selectedDay < _plans.length ? _plans[_selectedDay] : null;
    if (todayPlan == null) return const SizedBox();

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Plan')),
      body: Column(
        children: [
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _plans.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (_, i) {
                final plan = _plans[i];
                final isSelected = _selectedDay == i;
                final isRest = plan.workouts.isEmpty;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDay = i),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.orangeAccent.withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isSelected ? Colors.orangeAccent : Colors.white12,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          plan.day.substring(0, 3),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.orangeAccent
                                : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Icon(
                          isRest ? Icons.bedtime : Icons.fitness_center,
                          size: 20,
                          color:
                              isRest ? Colors.blue[300] : Colors.orangeAccent,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (todayPlan.workouts.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bedtime, size: 80, color: Colors.blue[300]),
                    const SizedBox(height: 16),
                    Text(
                      "Rest Day",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: Colors.blue[300]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Recovery is essential for growth!\nStretch, hydrate, and get good sleep.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: todayPlan.workouts.length + 1,
                itemBuilder: (_, i) {
                  if (i == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todayPlan.focus,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${todayPlan.workouts.length} exercises',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }
                  final workout = todayPlan.workouts[i - 1];
                  return _workoutCard(workout, i);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _workoutCard(Workout workout, int index) {
    IconData icon;
    switch (workout.category) {
      case 'push':
        icon = Icons.arrow_upward;
        break;
      case 'pull':
        icon = Icons.arrow_downward;
        break;
      case 'legs':
        icon = Icons.directions_walk;
        break;
      case 'core':
        icon = Icons.accessibility_new;
        break;
      case 'cardio':
        icon = Icons.directions_run;
        break;
      default:
        icon = Icons.fitness_center;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.orangeAccent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${workout.sets} sets x ${workout.reps} reps - ${workout.restSeconds}s rest',
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: workout.difficulty == 'beginner'
                    ? Colors.green.withValues(alpha: 0.2)
                    : Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                workout.difficulty,
                style: TextStyle(
                  color: workout.difficulty == 'beginner'
                      ? Colors.green[300]
                      : Colors.orange[300],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
