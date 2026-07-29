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

  void validate() {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty || normalizedName.length > 100) {
      throw ArgumentError.value(
        name,
        'name',
        'must be between 1 and 100 characters',
      );
    }
    if (age < 13 || age > 100) {
      throw ArgumentError.value(age, 'age', 'must be between 13 and 100');
    }
    if (!height.isFinite || height < 80 || height > 250) {
      throw ArgumentError.value(
        height,
        'height',
        'must be between 80 and 250 centimeters',
      );
    }
    if (!weight.isFinite || weight < 20 || weight > 300) {
      throw ArgumentError.value(
        weight,
        'weight',
        'must be between 20 and 300 kilograms',
      );
    }
    if (!const {'male', 'female'}.contains(gender)) {
      throw ArgumentError.value(gender, 'gender', 'must be male or female');
    }
    if (!const {'sedentary', 'light', 'moderate', 'active', 'very_active'}
        .contains(activityLevel)) {
      throw ArgumentError.value(
        activityLevel,
        'activityLevel',
        'contains an unsupported activity level',
      );
    }
    if (!const {'lose_weight', 'maintain', 'gain_muscle'}.contains(goal)) {
      throw ArgumentError.value(
        goal,
        'goal',
        'contains an unsupported goal',
      );
    }
    if (!bmi.isFinite || bmi <= 0) {
      throw ArgumentError.value(
        bmi,
        'bmi',
        'must be greater than 0',
      );
    }
  }

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

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final profile = UserProfile(
        name: _readString(json, 'name'),
        age: _readInt(json, 'age'),
        height: _readDouble(json, 'height'),
        weight: _readDouble(json, 'weight'),
        gender: _readString(json, 'gender'),
        activityLevel: _readString(json, 'activityLevel'),
        goal: _readString(json, 'goal'),
      );
    profile.validate();
    return profile;
  }
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
  if (value is num && value.isFinite && value == value.round()) {
    return value.toInt();
  }
  if (value is String) {
    final parsed = int.tryParse(value.trim());
    if (parsed != null) return parsed;
  }
  throw FormatException('Invalid user profile field: $key');
}

double _readDouble(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is num && value.isFinite) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value.trim());
    if (parsed != null && parsed.isFinite) return parsed;
  }
  throw FormatException('Invalid user profile field: $key');
}
