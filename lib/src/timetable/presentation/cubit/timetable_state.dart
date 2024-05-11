part of 'timetable_cubit.dart';

sealed class TimetableState extends Equatable {
  const TimetableState();

  @override
  List<Object> get props => [];
}

final class TimetableInitial extends TimetableState {}

class TimetableLoading extends TimetableState {}

class CourseFetched extends TimetableState {
  const CourseFetched(this.course);

  final Course course;

  @override
  List<Object> get props => [course];
}

class CoursesFetched extends TimetableState {
  const CoursesFetched(this.courses);

  final List<Course> courses;

  @override
  List<Object> get props => [courses.toSet()];
}

class CourseIdsSearched extends TimetableState {
  const CourseIdsSearched(this.courseIds);

  final List<String> courseIds;

  @override
  List<Object> get props => [courseIds.toSet()];
}

class SchoolsLoaded extends TimetableState {
  final List<String> schools;

  const SchoolsLoaded(this.schools);

  @override
  List<Object> get props => [schools];
}

class TimetableError extends TimetableState {
  const TimetableError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

// 전공선택
class SchoolSelected extends TimetableState {
  final String? selectedSchool;

  const SchoolSelected(this.selectedSchool);

  @override
  List<Object> get props => [selectedSchool!];
}

//시간표 저장
class CoursesUpdated extends TimetableState {
  final List<Course> courses;

  const CoursesUpdated(this.courses);

  @override
  List<Object> get props => [courses];
}