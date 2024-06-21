import 'package:uniberry/src/timetable/domain/entities/timetable.dart';

String timetablePeriodToJapanese(TimetablePeriod period) {
  const dayMap = {
    DayOfWeek.monday: '月',
    DayOfWeek.tuesday: '火',
    DayOfWeek.wednesday: '水',
    DayOfWeek.thursday: '木',
    DayOfWeek.friday: '金',
    DayOfWeek.saturday: '土',
    DayOfWeek.sunday: '日',
  };

  final dayInJapanese = dayMap[period.day];
  final periodInJapanese = period.period.index + 1;

  return '$dayInJapanese$periodInJapanese';
}
