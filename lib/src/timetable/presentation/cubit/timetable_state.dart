part of 'timetable_cubit.dart';

sealed class TimetableState extends Equatable {
  const TimetableState();

  @override
  List<Object?> get props => [];
}

final class TimetableInitial extends TimetableState {}

class TimetableLoading extends TimetableState {
  const TimetableLoading();
}

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

class TimetableCreated extends TimetableState {
  const TimetableCreated();
}

class TimetableRead extends TimetableState {
  const TimetableRead(this.timetable);

  final Timetable timetable;

  @override
  List<Object?> get props => [timetable];
}

class TimetableUpdateCompleted extends TimetableState {
  const TimetableUpdateCompleted();
}

class TimetableDeleted extends TimetableState {
  const TimetableDeleted();
}

class TimetablesFetched extends TimetableState {
  const TimetablesFetched(this.timetables);

  final List<Timetable> timetables;

  @override
  List<Object?> get props => [timetables];
}

class TimetableError extends TimetableState {
  const TimetableError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
