
class TimeframeEntry {
  final int projectIndex;
  final DateTime date;
  final int duration; // Duration in seconds

  TimeframeEntry({
    required this.projectIndex,
    required this.date,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'projectIndex': projectIndex,
      'date': date.toIso8601String(),
      'duration': duration,
    };
  }

  factory TimeframeEntry.fromMap(Map<String, dynamic> map) {
    return TimeframeEntry(
      projectIndex: map['projectIndex'] ?? 0,
      date: DateTime.parse(map['date']).toUtc(),
      duration: map['duration'] ?? 0,
    );
  }
}