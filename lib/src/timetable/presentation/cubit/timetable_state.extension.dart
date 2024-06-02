part of 'timetable_cubit.dart';

class SchoolsLoaded extends TimetableState {
  final List<String> schools;

  const SchoolsLoaded(this.schools);

  @override
  List<Object?> get props => [schools];
}

// 전공선택
class SchoolSelected extends TimetableState {
  final String? selectedSchool;

  const SchoolSelected(this.selectedSchool);

  @override
  List<Object?> get props => [selectedSchool];
}

// 학기변경
class SemesterSelected extends TimetableState {
  final String? selectedSchool;
  final String semester;

  const SemesterSelected({
    required this.selectedSchool,
    required this.semester,
  });

  @override
  List<Object?> get props => [selectedSchool, semester];
}

// 시간표 저장
class CoursesUpdated extends TimetableState {
  final Map<String, Course?> timetable;

  const CoursesUpdated(this.timetable);

  @override
  List<Object?> get props => [timetable];
}

// 새로운 상태 추가
class TimetableUpdated extends TimetableState {
  final int periods;
  final bool includeSaturday;
  final bool includeSunday;
  final List<String> timetables;

  const TimetableUpdated({
    required this.periods,
    required this.includeSaturday,
    required this.includeSunday,
    required this.timetables,
  });

  @override
  List<Object?> get props =>
      [periods, includeSaturday, includeSunday, timetables];
}
