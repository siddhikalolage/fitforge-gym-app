import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/user_profile.dart';
import '../models/progress_entry.dart';
import '../services/storage_service.dart';
import '../services/recommendation_engine.dart';

class DashboardScreen extends StatefulWidget {
  final UserProfile profile;

  const DashboardScreen({super.key, required this.profile});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _storageService = StorageService();
  List<ProgressEntry> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _storageService.getProgressHistory();
    if (!mounted) return;
    setState(() {
      _history = history;
      _loading = false;
    });
  }

  void _logProgress() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final alreadyLogged = _history.any(
      (e) =>
          e.date.year == today.year &&
          e.date.month == today.month &&
          e.date.day == today.day,
    );

    if (alreadyLogged) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Today\'s progress already logged!')),
      );
      return;
    }

    final weightController = TextEditingController(
      text: widget.profile.weight.toStringAsFixed(1),
    );

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          title: const Text(
            'Log Today\'s Progress',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weightController,
                style: const TextStyle(color: Colors.white),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Current Weight (kg)',
                  labelStyle: const TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final weight = double.tryParse(weightController.text.trim());
                if (weight == null || weight < 20 || weight > 300) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enter a valid weight in kilograms'),
                    ),
                  );
                  return;
                }

                final heightM = widget.profile.height / 100;
                final entry = ProgressEntry(
                  date: today,
                  weight: weight,
                  bmi: weight / (heightM * heightM),
                );

                Navigator.pop(ctx);
                await _storageService.saveProgressEntry(entry);
                if (!mounted) return;
                await _loadHistory();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    ).whenComplete(weightController.dispose);
  }

  @override
  Widget build(BuildContext context) {
    final bmi = widget.profile.bmi;
    final bmiCategory = widget.profile.bmiCategory;
    final waterIntake =
        RecommendationEngine.getRecommendedWaterIntake(widget.profile);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Welcome + BMI summary
                _buildHeader(bmi, bmiCategory),
                const SizedBox(height: 16),

                // Quick stats
                _buildQuickStats(waterIntake),
                const SizedBox(height: 16),

                // BMI Category card
                _buildBMICategoryCard(bmi, bmiCategory),
                const SizedBox(height: 16),

                // Progress chart
                _buildProgressChart(),
                const SizedBox(height: 16),

                // Log progress button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _logProgress,
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Log Today\'s Progress',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
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

  Widget _buildHeader(double bmi, String category) {
    Color categoryColor;
    IconData categoryIcon;
    switch (category) {
      case 'underweight':
        categoryColor = Colors.blue;
        categoryIcon = Icons.bolt;
        break;
      case 'normal':
        categoryColor = Colors.green;
        categoryIcon = Icons.fitness_center;
        break;
      case 'overweight':
        categoryColor = Colors.orange;
        categoryIcon = Icons.local_fire_department;
        break;
      case 'obese':
        categoryColor = Colors.red;
        categoryIcon = Icons.track_changes;
        break;
      default:
        categoryColor = Colors.grey;
        categoryIcon = Icons.monitor_weight;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: categoryColor.withValues(alpha: 0.2),
              ),
              child: Icon(categoryIcon, size: 32, color: categoryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${widget.profile.name}!',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'BMI: ${bmi.toStringAsFixed(1)} - ${_formatCategory(category)}',
                    style: TextStyle(
                      color: categoryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCategory(String category) {
    if (category.isEmpty) return category;
    return '${category[0].toUpperCase()}${category.substring(1)}';
  }

  Widget _buildQuickStats(double waterIntake) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            Icons.fitness_center,
            'Goal',
            widget.profile.goal == 'lose_weight'
                ? 'Lose Weight'
                : widget.profile.goal == 'gain_muscle'
                    ? 'Build Muscle'
                    : 'Maintain',
            Colors.orangeAccent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            Icons.water_drop,
            'Water',
            '${waterIntake}L / day',
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            Icons.calendar_today,
            'Logs',
            '${_history.length} entries',
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _statCard(IconData icon, String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.white60, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBMICategoryCard(double bmi, String category) {
    String range;
    switch (category) {
      case 'underweight':
        range = '< 18.5';
        break;
      case 'normal':
        range = '18.5 - 24.9';
        break;
      case 'overweight':
        range = '25 - 29.9';
        break;
      case 'obese':
        range = '30+';
        break;
      default:
        range = '';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'BMI Range: $range',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Your: ${bmi.toStringAsFixed(1)}',
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: [
                    Expanded(
                      flex: 18,
                      child: Container(color: Colors.blue[300]),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(color: Colors.green[400]),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(color: Colors.orange[400]),
                    ),
                    Expanded(
                      flex: 70,
                      child: Container(color: Colors.red[400]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Underweight',
                    style: TextStyle(color: Colors.white60, fontSize: 10)),
                Text('Normal',
                    style: TextStyle(color: Colors.white60, fontSize: 10)),
                Text('Overweight',
                    style: TextStyle(color: Colors.white60, fontSize: 10)),
                Text('Obese',
                    style: TextStyle(color: Colors.white60, fontSize: 10)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              RecommendationEngine.getMotivationalTip(category),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart() {
    if (_history.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.show_chart, size: 48, color: Colors.grey[600]),
              const SizedBox(height: 12),
              const Text(
                'No progress data yet',
                style: TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 4),
              const Text(
                'Log your first entry above!',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    final sortedHistory = List<ProgressEntry>.from(_history)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Show last 10 entries max
    final displayHistory = sortedHistory.length > 10
        ? sortedHistory.sublist(sortedHistory.length - 10)
        : sortedHistory;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weight Progress',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _getChartInterval(displayHistory),
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.white10,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}',
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 10),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= displayHistory.length) {
                            return const SizedBox();
                          }
                          return Text(
                            DateFormat('dd/MM')
                                .format(displayHistory[idx].date),
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 9),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(displayHistory.length, (i) {
                        return FlSpot(i.toDouble(), displayHistory[i].weight);
                      }),
                      isCurved: true,
                      color: Colors.orangeAccent,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: displayHistory.length <= 15,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.orangeAccent,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.orangeAccent.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                  minY: _getMinWeight(displayHistory) - 2,
                  maxY: _getMaxWeight(displayHistory) + 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getMinWeight(List<ProgressEntry> entries) {
    double min = double.infinity;
    for (final e in entries) {
      if (e.weight < min) min = e.weight;
    }
    return min;
  }

  double _getMaxWeight(List<ProgressEntry> entries) {
    double max = double.negativeInfinity;
    for (final e in entries) {
      if (e.weight > max) max = e.weight;
    }
    return max;
  }

  double _getChartInterval(List<ProgressEntry> entries) {
    final diff = _getMaxWeight(entries) - _getMinWeight(entries);
    if (diff <= 5) return 1;
    if (diff <= 15) return 3;
    return 5;
  }
}
