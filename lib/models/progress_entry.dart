class ProgressEntry {
  final DateTime date;
  final double weight;
  final double bmi;

  ProgressEntry({
    required this.date,
    required this.weight,
    required this.bmi,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'weight': weight,
        'bmi': bmi,
      };

  factory ProgressEntry.fromJson(Map<String, dynamic> json) => ProgressEntry(
        date: DateTime.parse(_readString(json, 'date')),
        weight: _readDouble(json, 'weight'),
        bmi: _readDouble(json, 'bmi'),
      );
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
  if (value is num) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value.trim());
    if (parsed != null) return parsed;
  }
  throw FormatException('Invalid progress entry field: $key');
}
