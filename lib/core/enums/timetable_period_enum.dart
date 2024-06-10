class TimetablePeriod {
  const TimetablePeriod(this.day, this.period);

  final DayOfWeek day;
  final Period period;

  @override
  String toString() {
    return '${day.toString().split('.').last}.${period.toString().split('.').last}';
  }
}

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

enum Period {
  period1,
  period2,
  period3,
  period4,
  period5,
  period6,
  period7,
  period8,
  period9,
}

// convert string to TimetablePeriod
TimetablePeriod stringToTimetablePeriod(String str) {
  final parts = str.split('.');
  final day = DayOfWeek.values
      .firstWhere((e) => e.toString().split('.').last == parts[0]);
  final period =
      Period.values.firstWhere((e) => e.toString().split('.').last == parts[1]);
  return TimetablePeriod(day, period);
}
