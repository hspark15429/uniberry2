part of 'timetable_cubit.dart';

sealed class TimetableState extends Equatable {
  const TimetableState();

  @override
  List<Object?> get props => [];
}

final class TimetableInitial extends TimetableState {}

class TimetableLoading extends TimetableState {}

class CourseFetched extends TimetableState {
  const CourseFetched(this.course);

  final Course course;

  @override
  List<Object?> get props => [course];
}

class CoursesFetched extends TimetableState {
  const CoursesFetched(this.courses);

  final List<Course> courses;

  @override
  List<Object?> get props => [courses];
}

class CourseIdsSearched extends TimetableState {
  const CourseIdsSearched(this.courseIds);

  final List<String> courseIds;

  @override
  List<Object?> get props => [courseIds];
}

class SchoolsLoaded extends TimetableState {
  final List<String> schools;

  const SchoolsLoaded(this.schools);

  @override
  List<Object?> get props => [schools];
}

class TimetableError extends TimetableState {
  const TimetableError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
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

  const TimetableUpdated({
    required this.periods,
    required this.includeSaturday,
    required this.includeSunday, required Map timetable,
  });

  @override
  List<Object?> get props => [periods, includeSaturday, includeSunday];
}
