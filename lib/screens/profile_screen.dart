import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/user_profile.dart';
import '../repositories/fitforge_repository.dart';
import '../repositories/local_fitforge_repository.dart';
import 'onboarding_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile profile;
  final FitForgeRepository? repository;
  final ValueChanged<UserProfile>? onProfileUpdated;

  const ProfileScreen({
    super.key,
    required this.profile,
    this.repository,
    this.onProfileUpdated,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final FitForgeRepository _repository;
  bool _savingProfile = false;
  bool _exportingData = false;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? LocalFitForgeRepository();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final bmi = profile.bmi;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
                  child: const Icon(
                    Icons.person,
                    size: 48,
                    color: Colors.orangeAccent,
                  ),
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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _profileRow('Height', '${profile.height} cm', Icons.height),
                  const Divider(color: Colors.white12),
                  _profileRow(
                    'Weight',
                    '${profile.weight} kg',
                    Icons.monitor_weight,
                  ),
                  const Divider(color: Colors.white12),
                  _profileRow('BMI', bmi.toStringAsFixed(1), Icons.calculate),
                  const Divider(color: Colors.white12),
                  _profileRow(
                    'Gender',
                    profile.gender == 'male' ? 'Male' : 'Female',
                    Icons.person_outline,
                  ),
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _savingProfile ? null : _editProfile,
              icon: _savingProfile
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.edit),
              label: Text(_savingProfile ? 'Saving...' : 'Edit Profile'),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lock_outline, color: Colors.orangeAccent),
                      SizedBox(width: 12),
                      Text(
                        'Privacy & Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your profile and progress are stored locally using secure storage. Exported data leaves the device only when you choose a destination in the system share sheet.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _exportingData ? null : _exportData,
                      icon: _exportingData
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.ios_share),
                      label: Text(
                        _exportingData
                            ? 'Preparing export...'
                            : 'Export My Data',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () => _resetApp(context),
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              label: const Text(
                'Delete Local Data',
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

  Future<void> _editProfile() async {
    final updatedProfile = await showDialog<UserProfile>(
      context: context,
      builder: (_) => EditProfileDialog(profile: widget.profile),
    );
    if (updatedProfile == null || !mounted) return;

    setState(() => _savingProfile = true);
    try {
      await _repository.saveUserProfile(updatedProfile);
      if (!mounted) return;
      widget.onProfileUpdated?.call(updatedProfile);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated securely')));
    } on RepositoryException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } on ArgumentError {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please review your profile details and try again'),
        ),
      );
    } finally {
      if (mounted) setState(() => _savingProfile = false);
    }
  }

  Future<void> _exportData() async {
    setState(() => _exportingData = true);
    try {
      final export = await _repository.exportData();
      if (!mounted) return;
      await SharePlus.instance.share(
        ShareParams(text: export, subject: 'FitForge data export'),
      );
    } on RepositoryException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } on Exception {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to start the data export. Please try again'),
        ),
      );
    } finally {
      if (mounted) setState(() => _exportingData = false);
    }
  }

  void _resetApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Delete local data?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This permanently deletes your profile and progress from this device. Export anything you need first.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _repository.resetAll();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => OnboardingScreen(repository: _repository),
                  ),
                  (_) => false,
                );
              } on RepositoryException catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(error.message)));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class EditProfileDialog extends StatefulWidget {
  final UserProfile profile;

  const EditProfileDialog({super.key, required this.profile});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late String _gender;
  late String _activityLevel;
  late String _goal;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;
    _nameController = TextEditingController(text: profile.name);
    _ageController = TextEditingController(text: profile.age.toString());
    _heightController = TextEditingController(text: profile.height.toString());
    _weightController = TextEditingController(text: profile.weight.toString());
    _gender = profile.gender;
    _activityLevel = profile.activityLevel;
    _goal = profile.goal;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: _validateName,
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: _validateAge,
                ),
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) => _validateDecimal(
                    value,
                    minimum: 80,
                    maximum: 250,
                    label: 'height',
                  ),
                ),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) => _validateDecimal(
                    value,
                    minimum: 20,
                    maximum: 300,
                    label: 'weight',
                  ),
                ),
                DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _gender = value);
                  },
                ),
                DropdownButtonFormField<String>(
                  initialValue: _activityLevel,
                  decoration: const InputDecoration(labelText: 'Activity'),
                  items: const [
                    DropdownMenuItem(
                      value: 'sedentary',
                      child: Text('Sedentary'),
                    ),
                    DropdownMenuItem(value: 'light', child: Text('Light')),
                    DropdownMenuItem(
                      value: 'moderate',
                      child: Text('Moderate'),
                    ),
                    DropdownMenuItem(value: 'active', child: Text('Active')),
                    DropdownMenuItem(
                      value: 'very_active',
                      child: Text('Very active'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _activityLevel = value);
                    }
                  },
                ),
                DropdownButtonFormField<String>(
                  initialValue: _goal,
                  decoration: const InputDecoration(labelText: 'Goal'),
                  items: const [
                    DropdownMenuItem(
                      value: 'lose_weight',
                      child: Text('Lose weight'),
                    ),
                    DropdownMenuItem(
                      value: 'maintain',
                      child: Text('Maintain'),
                    ),
                    DropdownMenuItem(
                      value: 'gain_muscle',
                      child: Text('Build muscle'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _goal = value);
                  },
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final profile = UserProfile(
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      height: double.parse(_heightController.text.trim()),
      weight: double.parse(_weightController.text.trim()),
      gender: _gender,
      activityLevel: _activityLevel,
      goal: _goal,
    );

    try {
      profile.validate();
      Navigator.pop(context, profile);
    } on ArgumentError {
      setState(() {
        _errorMessage = 'Please review your profile details and try again';
      });
    }
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Enter your name';
    if (name.length > 100) return 'Keep your name under 100 characters';
    return null;
  }

  String? _validateAge(String? value) {
    final age = int.tryParse(value?.trim() ?? '');
    if (age == null || age < 13 || age > 100) {
      return 'Enter an age between 13 and 100';
    }
    return null;
  }

  String? _validateDecimal(
    String? value, {
    required double minimum,
    required double maximum,
    required String label,
  }) {
    final number = double.tryParse(value?.trim() ?? '');
    if (number == null ||
        !number.isFinite ||
        number < minimum ||
        number > maximum) {
      return 'Enter a valid $label';
    }
    return null;
  }
}
