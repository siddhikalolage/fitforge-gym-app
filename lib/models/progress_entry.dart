class ProgressEntry {
  final DateTime date;
  final double weight;
  final double bmi;

  ProgressEntry({
    required this.date,
    required this.weight,
    required this.bmi,
  });

  void validate() {
    if (!weight.isFinite || weight < 20 || weight > 300) {
      throw ArgumentError.value(
        weight,
        'weight',
        'must be between 20 and 300 kilograms',
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

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'weight': weight,
        'bmi': bmi,
      };

  factory ProgressEntry.fromJson(Map<String, dynamic> json) {
    final entry = ProgressEntry(
      date: DateTime.parse(_readString(json, 'date')),
      weight: _readDouble(json, 'weight'),
      bmi: _readDouble(json, 'bmi'),
    );
    entry.validate();
    return entry;
  }
}

String _readString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  throw FormatException('Invalid progress entry field: $key');
}

double _readDouble(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is num && value.isFinite) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value.trim());
    if (parsed != null && parsed.isFinite) return parsed;
  }
  throw FormatException('Invalid progress entry field: $key');
}
