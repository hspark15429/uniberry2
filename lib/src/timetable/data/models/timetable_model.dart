import 'dart:convert';

import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/timetable/domain/entities/timetable.dart';

class TimetableModel extends Timetable {
  const TimetableModel({
    required super.timetableId,
    required super.uid,
    required super.name,
    required super.timetableMap,
    super.numOfDays = 5,
    super.numOfPeriods = 7,
  });

  TimetableModel.empty()
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

  factory TimetableModel.fromJson(String source) => TimetableModel.fromMap(
        jsonDecode(source) as DataMap,
      );

  TimetableModel.fromMap(DataMap map)
      : this(
          timetableId: map['timetableId'] as String,
          uid: map['uid'] as String,
          name: map['name'] as String,
          timetableMap: (map['timetableMap'] as DataMap).map(
            (period, courseId) => MapEntry(
              TimetablePeriod.fromString(period),
              courseId as String?,
            ),
          ),
          numOfDays: map['numOfDays'] as int? ?? 5,
          numOfPeriods: map['numOfPeriods'] as int? ?? 7,
        );

  String toJson() => jsonEncode(toMap());

  DataMap toMap() {
    return {
      'timetableId': timetableId,
      'uid': uid,
      'name': name,
      'timetableMap': timetableMap.map(
        (period, courseId) => MapEntry(
          period.toString(),
          courseId,
        ),
      ),
      'numOfDays': numOfDays,
      'numOfPeriods': numOfPeriods,
    };
  }

  TimetableModel copyWith({
    String? timetableId,
    String? uid,
    String? name,
    Map<TimetablePeriod, String?>? timetableMap,
    int? numOfDays,
    int? numOfPeriods,
  }) {
    return TimetableModel(
      timetableId: timetableId ?? this.timetableId,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      timetableMap: timetableMap ?? this.timetableMap,
      numOfDays: numOfDays ?? this.numOfDays,
      numOfPeriods: numOfPeriods ?? this.numOfPeriods,
    );
  }
}
