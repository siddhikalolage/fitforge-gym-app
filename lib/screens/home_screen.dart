import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../repositories/fitforge_repository.dart';
import '../repositories/local_fitforge_repository.dart';
import 'dashboard_screen.dart';
import 'onboarding_screen.dart';
import 'workout_plan_screen.dart';
import 'diet_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final FitForgeRepository? repository;

  const HomeScreen({super.key, this.repository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FitForgeRepository _repository;
  UserProfile? _profile;
  bool _loading = true;
  String? _loadError;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? LocalFitForgeRepository();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _repository.getUserProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _loadError = null;
        _loading = false;
      });
    } on RepositoryException catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error.message;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_loadError != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Profile unavailable',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                const SizedBox(height: 12),
                Text(
                  _loadError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _loading = true;
                      _loadError = null;
                    });
                    _loadProfile();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_profile == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Profile not found',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => OnboardingScreen(repository: _repository),
                      // Keep the active repository boundary across flows.
                    ),
                  );
                },
                child: const Text('Create Profile'),
              ),
            ],
          ),
        ),
      );
    }

    final screens = [
      DashboardScreen(profile: _profile!, repository: _repository),
      WorkoutPlanScreen(profile: _profile!),
      DietScreen(profile: _profile!),
      ProfileScreen(
        profile: _profile!,
        repository: _repository,
        onProfileUpdated: (profile) {
          setState(() => _profile = profile);
        },
      ),
    ];

    return Scaffold(
      body: screens[_currentTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Diet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
