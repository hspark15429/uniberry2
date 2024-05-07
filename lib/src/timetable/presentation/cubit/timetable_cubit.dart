import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/domain/usecases/get_course.dart';
import 'package:uniberry2/src/timetable/domain/usecases/search_courses.dart';

part 'timetable_state.dart';

class TimetableCubit extends Cubit<TimetableState> {
  TimetableCubit({
    required GetCourse getCourse,
    required SearchCourses searchCourses,
  })  : _getCourse = getCourse,
        _searchCourses = searchCourses,
        super(TimetableInitial());

  final GetCourse _getCourse;
  final SearchCourses _searchCourses;

  Future<void> getCourse(String courseId) async {
    emit(TimetableLoading());
    final course = await _getCourse(courseId);
    course.fold(
      (failure) => emit(TimetableError(failure.errorMessage)),
      (course) => emit(CourseFetched(course)),
    );
  }

  Future<void> getCourses(List<String> courseIds) async {
    emit(TimetableLoading());

    final courses = await Future.wait(courseIds.map((courseId) async {
      final result = await _getCourse(courseId);
      return result.fold(
        (failure) => null,
        (course) => course,
      );
    }));

    final validCourses = courses.whereType<Course>().toList();

    if (validCourses.isEmpty) {
      emit(const TimetableError('No courses found'));
      return;
    }
    emit(CoursesFetched(validCourses));
  }

  Future<void> searchCourses({
    String? school,
    String? campus,
    String? term,
    String? period,
  }) async {
    emit(TimetableLoading());

    final courseIds = await _searchCourses(SearchCoursesParams(
      school: school,
      campus: campus,
      term: term,
      period: period,
    ));

    courseIds.fold(
      (failure) => emit(TimetableError(failure.errorMessage)),
      (courseIds) => emit(CourseIdsSearched(courseIds)),
    );
  }

  void loadMoreCourses() {}
}