import 'package:equatable/equatable.dart';
import 'package:uniberry/core/utils/typedefs.dart';

class Timetable extends Equatable {
  const Timetable({
    required this.timetableId,
    required this.uid,
    required this.name,
    required this.timetableMap,
    this.numOfDays = 5,
    this.numOfPeriods = 7,
  });

  Timetable.empty()
      : this(
          timetableId: '_empty.timetableId',
          uid: '_empty.uid',
          name: '_empty.name',
          timetableMap: {
            const TimetablePeriod(
              day: DayOfWeek.monday,
              period: Period.period1,
            ): '_empty.courseId',
          },
          numOfDays: 5,
          numOfPeriods: 7,
        );

  final String timetableId;
  final String uid;
  final String name;
  final Map<TimetablePeriod, String?> timetableMap;
  final int numOfDays;
  final int numOfPeriods;

  @override
  List<Object?> get props =>
      [timetableId, uid, name, timetableMap, numOfDays, numOfPeriods];

  @override
  String toString() {
    return 'Timetable(timetableId: $timetableId, '
        'name: $name, timetableMap: $timetableMap, '
        'numOfDays: $numOfDays, numOfPeriods: $numOfPeriods)';
  }
}

class TimetablePeriod extends Equatable {
  const TimetablePeriod({
    required this.day,
    required this.period,
  });

  TimetablePeriod.fromString(String str)
      : day = DayOfWeek.values.firstWhere(
          (e) => e.name == str.split('.')[0],
        ),
        period = Period.values.firstWhere(
          (e) => e.name == str.split('.')[1],
        );

  final DayOfWeek day;
  final Period period;

  @override
  String toString() {
    return '${day.name}.${period.name}';
  }

  @override
  List<Object?> get props => [day, period];
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
  period10,
  period11,
  period12,
}
