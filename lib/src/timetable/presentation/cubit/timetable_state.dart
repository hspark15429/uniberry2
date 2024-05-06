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

class CourseIdsSearched extends TimetableState {
  const CourseIdsSearched(this.courseIds);

  final List<String> courseIds;

  @override
  List<Object> get props => [courseIds.toSet()];
}

class TimetableError extends TimetableState {
  const TimetableError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
