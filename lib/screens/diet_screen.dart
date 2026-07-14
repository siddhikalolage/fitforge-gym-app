import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/workout.dart';
import '../services/recommendation_engine.dart';

class DietScreen extends StatelessWidget {
  final UserProfile profile;

  const DietScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final dietPlan = RecommendationEngine.generateDietPlan(profile);
    final bmi = profile.bmi;
    final waterIntake = RecommendationEngine.getRecommendedWaterIntake(profile);

    return Scaffold(
      appBar: AppBar(title: const Text('Diet Plan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Calorie summary card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Daily Target',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${dietPlan.dailyCalories}',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Colors.orangeAccent, fontSize: 48),
                  ),
                  Text(
                    'calories',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _infoChip(
                          'BMI', bmi.toStringAsFixed(1), Icons.monitor_weight),
                      const SizedBox(width: 16),
                      _infoChip('Water', '${waterIntake}L', Icons.water_drop),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Meals
          ...dietPlan.meals.map((meal) => _mealCard(context, meal)),

          const SizedBox(height: 20),

          // Notes
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb,
                          color: Colors.orangeAccent, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Tips & Notes',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dietPlan.notes,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Motivational tip
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      RecommendationEngine.getMotivationalTip(
                          profile.bmiCategory),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _infoChip(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.orangeAccent, size: 24),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }

  Widget _mealCard(BuildContext context, Meal meal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        meal.name == 'Breakfast'
                            ? Icons.wb_sunny
                            : meal.name == 'Lunch'
                                ? Icons.wb_cloudy
                                : meal.name == 'Snack'
                                    ? Icons.cookie
                                    : Icons.nights_stay,
                        color: Colors.orangeAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          meal.time,
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${meal.calories}',
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'cal',
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(color: Colors.white12, height: 24),
            ...meal.foods.map((food) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.circle,
                          size: 6, color: Colors.orangeAccent),
                      const SizedBox(width: 8),
                      Text(food,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                )),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                meal.macros,
                style: TextStyle(
                    color: Colors.green[300],
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
