import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';

class TimetableModel extends Timetable {
  const TimetableModel({
    required super.timetableId,
    required super.uid,
    required super.name,
    required super.timetableMap,
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
        );

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
    };
  }

  TimetableModel copyWith({
    String? timetableId,
    String? uid,
    String? name,
    Map<TimetablePeriod, String?>? timetableMap,
  }) {
    return TimetableModel(
      timetableId: timetableId ?? this.timetableId,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      timetableMap: timetableMap ?? this.timetableMap,
    );
  }
}
