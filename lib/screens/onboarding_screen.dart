import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _storageService = StorageService();

  String _gender = 'male';
  String _activityLevel = 'sedentary';
  String _goal = 'maintain';
  bool _privacyAccepted = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _heightController.addListener(_refreshBmiPreview);
    _weightController.addListener(_refreshBmiPreview);
  }

  @override
  void dispose() {
    _heightController.removeListener(_refreshBmiPreview);
    _weightController.removeListener(_refreshBmiPreview);
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _refreshBmiPreview() {
    if (mounted) {
      setState(() {});
    }
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim());
    final height = double.tryParse(_heightController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());
    final validationMessage = _validateInputs(
      name: name,
      age: age,
      height: height,
      weight: weight,
    );

    if (validationMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationMessage)),
      );
      return;
    }

    if (!_privacyAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept secure local data storage to continue'),
        ),
      );
      return;
    }

    final profile = UserProfile(
      name: name,
      age: age!,
      height: height!,
      weight: weight!,
      gender: _gender,
      activityLevel: _activityLevel,
      goal: _goal,
    );

    await _storageService.saveUserProfile(profile);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  String? _validateInputs({
    required String name,
    required int? age,
    required double? height,
    required double? weight,
  }) {
    if (name.isEmpty) return 'Please enter your name';
    if (age == null || age < 13 || age > 100) {
      return 'Please enter an age between 13 and 100';
    }
    if (height == null || height < 80 || height > 250) {
      return 'Please enter a valid height in centimeters';
    }
    if (weight == null || weight < 20 || weight > 300) {
      return 'Please enter a valid weight in kilograms';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (i) => setState(() => _currentPage = i),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildWelcomePage(),
            _buildPersonalInfoPage(),
            _buildBodyMetricsPage(),
            _buildGoalsPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orangeAccent.withValues(alpha: 0.15),
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 64,
              color: Colors.orangeAccent,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Welcome to FitForge',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'Your personal AI-powered gym companion.\nGet personalized workout & diet plans based on your BMI.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('About You', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(
            'Tell us a bit about yourself',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Your Name', Icons.person),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ageController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: _inputDecoration('Age', Icons.cake),
          ),
          const SizedBox(height: 16),
          Text('Gender', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _genderChip('male', Icons.male),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _genderChip('female', Icons.female),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderChip(String gender, IconData icon) {
    final isSelected = _gender == gender;
    return GestureDetector(
      onTap: () => setState(() => _gender = gender),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.orangeAccent.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.orangeAccent : Colors.white24,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? Colors.orangeAccent : Colors.white60),
            const SizedBox(width: 8),
            Text(
              gender == 'male' ? 'Male' : 'Female',
              style: TextStyle(
                color: isSelected ? Colors.orangeAccent : Colors.white60,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyMetricsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('Body Metrics',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(
            'Enter your height and weight for BMI calculation',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _heightController,
            style: const TextStyle(color: Colors.white),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _inputDecoration('Height (cm)', Icons.height),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _weightController,
            style: const TextStyle(color: Colors.white),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _inputDecoration('Weight (kg)', Icons.monitor_weight),
          ),
          if (_heightController.text.isNotEmpty &&
              _weightController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: _buildBMIPreview(),
            ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBMIPreview() {
    final height = double.tryParse(_heightController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0;
    if (height <= 0 || weight <= 0) return const SizedBox();

    final bmi = weight / ((height / 100) * (height / 100));
    final category = bmi < 18.5
        ? 'Underweight'
        : bmi < 25
            ? 'Normal'
            : bmi < 30
                ? 'Overweight'
                : 'Obese';
    final color = bmi < 18.5
        ? Colors.blue
        : bmi < 25
            ? Colors.green
            : bmi < 30
                ? Colors.orange
                : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: color, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your BMI: ${bmi.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Category: $category',
                  style: TextStyle(color: color, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('Your Goals', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(
            'What do you want to achieve?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Text('Fitness Goal', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          ...['lose_weight', 'maintain', 'gain_muscle'].map((g) => _goalOption(
                g,
                g == 'lose_weight'
                    ? 'Lose Weight'
                    : g == 'maintain'
                        ? 'Maintain Weight'
                        : 'Build Muscle',
                g == 'lose_weight'
                    ? Icons.trending_down
                    : g == 'maintain'
                        ? Icons.balance
                        : Icons.trending_up,
              )),
          const SizedBox(height: 24),
          Text(
            'Activity Level',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          _activityDropdown(),
          const SizedBox(height: 24),
          _privacyConsentCard(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Create My Plan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _goalOption(String value, String label, IconData icon) {
    final isSelected = _goal == value;
    return GestureDetector(
      onTap: () => setState(() => _goal = value),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.orangeAccent.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.orangeAccent : Colors.white24,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? Colors.orangeAccent : Colors.white60),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.orangeAccent : Colors.white60,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityDropdown() {
    final levels = {
      'sedentary': 'Sedentary (little or no exercise)',
      'light': 'Lightly active (1-3 days/week)',
      'moderate': 'Moderately active (3-5 days/week)',
      'active': 'Very active (6-7 days/week)',
      'very_active': 'Extremely active (athlete)',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _activityLevel,
          isExpanded: true,
          dropdownColor: const Color(0xFF1A1A2E),
          style: const TextStyle(color: Colors.white, fontSize: 15),
          items: levels.entries
              .map((e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(e.value),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _activityLevel = v!),
        ),
      ),
    );
  }

  Widget _privacyConsentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _privacyAccepted ? Colors.orangeAccent : Colors.white24,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _privacyAccepted,
            activeColor: Colors.orangeAccent,
            onChanged: (value) {
              setState(() => _privacyAccepted = value ?? false);
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'I agree to store my profile and progress securely on this device so FitForge can personalize my workout and diet plans.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60),
      prefixIcon: Icon(icon, color: Colors.orangeAccent),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.orangeAccent),
      ),
    );
  }
}
