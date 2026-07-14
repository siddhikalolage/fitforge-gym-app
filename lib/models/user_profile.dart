class UserProfile {
  final String name;
  final int age;
  final double height;
  final double weight;
  final String gender; // male, female
  final String activityLevel; // sedentary, light, moderate, active, very_active
  final String goal; // lose_weight, maintain, gain_muscle

  UserProfile({
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.activityLevel,
    required this.goal,
  });

  double get bmi =>
      height <= 0 ? 0 : weight / ((height / 100) * (height / 100));

  String get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue < 18.5) return 'underweight';
    if (bmiValue < 25) return 'normal';
    if (bmiValue < 30) return 'overweight';
    return 'obese';
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'height': height,
        'weight': weight,
        'gender': gender,
        'activityLevel': activityLevel,
        'goal': goal,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: _readString(json, 'name'),
        age: _readInt(json, 'age'),
        height: _readDouble(json, 'height'),
        weight: _readDouble(json, 'weight'),
        gender: _readString(json, 'gender'),
        activityLevel: _readString(json, 'activityLevel'),
        goal: _readString(json, 'goal'),
      );
}

String _readString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  throw FormatException('Invalid user profile field: $key');
}

int _readInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is int) return value;
  if (value is num) return value.round();
  if (value is String) {
    final parsed = int.tryParse(value.trim());
    if (parsed != null) return parsed;
  }
  throw FormatException('Invalid user profile field: $key');
}

double _readDouble(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is num) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value.trim());
    if (parsed != null) return parsed;
  }
  throw FormatException('Invalid user profile field: $key');
}
