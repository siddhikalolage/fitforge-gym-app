import 'dart:async';

import 'package:flutter/material.dart';

import '../models/workout.dart';
import '../models/workout_session.dart';
import '../services/workout_session_service.dart';

class WorkoutSessionScreen extends StatefulWidget {
  final WorkoutPlan plan;

  const WorkoutSessionScreen({super.key, required this.plan});

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  late WorkoutSession _session;

  final WorkoutSessionService _sessionService = WorkoutSessionService();

  int _currentExercise = 0;
  int _restSecondsRemaining = 0;

  Timer? _restTimer;

  @override
  void initState() {
    super.initState();

    _session = _sessionService.createSession(widget.plan);
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }

  Workout get _currentWorkout {
    return widget.plan.workouts[_currentExercise];
  }

  WorkoutExerciseProgress get _currentProgress {
    return _session.exercises[_currentExercise];
  }

  void _completeSet() {
    _sessionService.completeSet(_session, _currentExercise);

    if (_currentProgress.isCompleted) {
      if (_currentExercise < widget.plan.workouts.length - 1) {
        setState(() {
          _currentExercise++;
          _startRest(_currentWorkout.restSeconds);
        });
      } else {
        setState(() {});
        _showWorkoutComplete();
      }

      return;
    }

    setState(() {});
    _startRest(_currentWorkout.restSeconds);
  }

  void _startRest(int seconds) {
    _restTimer?.cancel();

    if (seconds <= 0) {
      setState(() {
        _restSecondsRemaining = 0;
      });
      return;
    }

    setState(() {
      _restSecondsRemaining = seconds;
    });

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_restSecondsRemaining <= 1) {
        timer.cancel();

        setState(() {
          _restSecondsRemaining = 0;
        });

        return;
      }

      setState(() {
        _restSecondsRemaining--;
      });
    });
  }

  void _skipRest() {
    _restTimer?.cancel();

    setState(() {
      _restSecondsRemaining = 0;
    });
  }

  void _showWorkoutComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Workout Complete 🎉'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events,
                size: 64,
                color: Colors.orangeAccent,
              ),
              const SizedBox(height: 16),
              Text(
                '${_session.completedSets}/${_session.totalSets} sets completed',
              ),
              const SizedBox(height: 8),
              const Text(
                'Great work! Your workout has been completed.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Finish'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final workout = _currentWorkout;
    final progress = _currentProgress;

    return Scaffold(
      appBar: AppBar(title: Text(widget.plan.day)),
      body: Column(
        children: [
          LinearProgressIndicator(value: _session.progress, minHeight: 5),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  widget.plan.focus,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: 8),

                Text(
                  'Exercise ${_currentExercise + 1} of '
                  '${widget.plan.workouts.length}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 28),

                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 72,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  workout.name,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),

                const SizedBox(height: 8),

                Text(
                  '${workout.sets} sets × ${workout.reps} reps',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: 24),

                _buildSetProgress(progress),

                const SizedBox(height: 24),

                if (_restSecondsRemaining > 0) _buildRestTimer(),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _restSecondsRemaining > 0 ? null : _completeSet,
                    icon: const Icon(Icons.check),
                    label: Text(
                      progress.isCompleted
                          ? 'Exercise Completed'
                          : 'Complete Set',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetProgress(WorkoutExerciseProgress progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sets', style: Theme.of(context).textTheme.headlineMedium),

        const SizedBox(height: 12),

        Row(
          children: List.generate(progress.totalSets, (index) {
            final completed = index < progress.completedSets;

            return Expanded(
              child: Container(
                height: 48,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: completed
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: completed ? Colors.green : Colors.white12,
                  ),
                ),
                child: Center(
                  child: completed
                      ? const Icon(Icons.check, color: Colors.green)
                      : Text('Set ${index + 1}'),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRestTimer() {
    final minutes = _restSecondsRemaining ~/ 60;
    final seconds = _restSecondsRemaining % 60;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('REST'),

          const SizedBox(height: 8),

          Text(
            '${minutes.toString().padLeft(2, '0')}:'
            '${seconds.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
          ),

          const SizedBox(height: 12),

          TextButton(onPressed: _skipRest, child: const Text('Skip Rest')),
        ],
      ),
    );
  }
}
