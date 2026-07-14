import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';
import 'onboarding_screen.dart';

class ProfileScreen extends StatelessWidget {
  final UserProfile profile;

  const ProfileScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final bmi = profile.bmi;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar & name
          Center(
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orangeAccent.withValues(alpha: 0.2),
                  ),
                  child:
                      Icon(Icons.person, size: 48, color: Colors.orangeAccent),
                ),
                const SizedBox(height: 12),
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '${profile.age} years old',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stats grid
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _profileRow('Height', '${profile.height} cm', Icons.height),
                  const Divider(color: Colors.white12),
                  _profileRow(
                      'Weight', '${profile.weight} kg', Icons.monitor_weight),
                  const Divider(color: Colors.white12),
                  _profileRow('BMI', bmi.toStringAsFixed(1), Icons.calculate),
                  const Divider(color: Colors.white12),
                  _profileRow(
                      'Gender',
                      profile.gender == 'male' ? 'Male' : 'Female',
                      Icons.person_outline),
                  const Divider(color: Colors.white12),
                  _profileRow(
                    'Goal',
                    profile.goal == 'lose_weight'
                        ? 'Lose Weight'
                        : profile.goal == 'gain_muscle'
                            ? 'Build Muscle'
                            : 'Maintain',
                    Icons.flag,
                  ),
                  const Divider(color: Colors.white12),
                  _profileRow(
                    'Activity',
                    profile.activityLevel.replaceAll('_', ' '),
                    Icons.directions_run,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Reset button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () => _resetApp(context),
              icon: const Icon(Icons.refresh, color: Colors.redAccent),
              label: const Text(
                'Reset Profile & Start Over',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _profileRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.orangeAccent, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 15),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _resetApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Reset App', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This will delete all your data. Are you sure?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final storage = StorageService();
              await storage.init();
              await storage.resetAll();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                (_) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
