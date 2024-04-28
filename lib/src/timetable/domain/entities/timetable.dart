import 'package:equatable/equatable.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';

class Timetable extends Equatable {
  const Timetable({required this.timetable});

  final Map<TimetableIndex, Course> timetable;

  @override
  List<Object?> get props => [timetable];
}

class TimetableIndex extends Equatable {
  const TimetableIndex({required this.index})
      : assert(index >= 0 && index < 50);

  final int index;

  @override
  List<Object?> get props => [index];
}
