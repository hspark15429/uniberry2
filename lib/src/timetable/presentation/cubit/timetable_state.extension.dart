part of 'timetable_cubit.dart';

class SchoolsLoaded extends TimetableState {

  const SchoolsLoaded(this.schools);
  final List<String> schools;

  @override
  List<Object?> get props => [schools];
}

// 전공선택
class SchoolSelected extends TimetableState {

  const SchoolSelected(this.selectedSchool);
  final String? selectedSchool;

  @override
  List<Object?> get props => [selectedSchool];
}

// 학기변경
class SemesterSelected extends TimetableState {

  const SemesterSelected({
    required this.selectedSchool,
    required this.semester,
  });
  final String? selectedSchool;
  final String semester;

  @override
  List<Object?> get props => [selectedSchool, semester];
}

// 시간표 저장
class CoursesUpdated extends TimetableState {

  const CoursesUpdated(this.timetable);
  final Map<String, Course?> timetable;

  @override
  List<Object?> get props => [timetable];
}

// 새로운 상태 추가
class TimetableUpdated extends TimetableState {

  const TimetableUpdated({
    required this.periods,
    required this.includeSaturday,
    required this.includeSunday,
    required this.timetables,
  });
  final int periods;
  final bool includeSaturday;
  final bool includeSunday;
  final List<String> timetables;

  @override
  List<Object?> get props =>
      [periods, includeSaturday, includeSunday, timetables];
}
