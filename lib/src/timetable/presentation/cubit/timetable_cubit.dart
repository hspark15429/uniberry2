library timetable_cubit;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/domain/usecases/get_course.dart';
import 'package:uniberry2/src/timetable/domain/usecases/search_courses.dart';

part 'timetable_state.dart';
part 'timetable_cubit.extension.dart';
part 'timetable_state.extension.dart';

class TimetableCubit extends Cubit<TimetableState> {
  TimetableCubit({
    required GetCourse getCourse,
    required SearchCourses searchCourses,
  })  : _getCourse = getCourse,
        _searchCourses = searchCourses,
        super(TimetableInitial());

  final GetCourse _getCourse;
  final SearchCourses _searchCourses;
  final List<String> _schools = [
    "法学部",
    "経済学部",
    "経営学部",
    // 다른 학부 추가
  ];

  ///
  ///
  ///
  /// cubit.extension을 위한 변수들 선언
  final Map<String, Map<String, Course?>> _semesterTimetables =
      {}; // 학기별 시간표 저장
  final List<String> _timetables = []; // 시간표 목록 추가

  String? _selectedSchool; // 선택된 학부 상태

  // 설정 관련 상태 초기값
  int _periods = 5;
  bool _includeSaturday = false;
  bool _includeSunday = false;

  List<String> get schools => _schools;
  Map<String, Map<String, Course?>> get semesterTimetables =>
      _semesterTimetables;
  List<String> get timetables => _timetables; // 시간표 목록 getter 추가
  String? get selectedSchool =>
      _selectedSchool; // 선택된 학부를 외부에서 가져올 수 있게 getter 추가

  int get periods => _periods;
  bool get includeSaturday => _includeSaturday;
  bool get includeSunday => _includeSunday;

  /// cubit.extension을 위한 변수들 선언 종료
  ///
  ///
  ///

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

    final courses = <Course?>[];
    for (final courseId in courseIds) {
      final result = await _getCourse(courseId);
      final course = result.fold(
        (failure) => null,
        (course) => course,
      );
      courses.add(course);
    }

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

    final courseIds = await _searchCourses(
      SearchCoursesParams(
        school: _selectedSchool ?? school,
        campus: campus,
        term: term,
        period: period,
      ),
    );

    courseIds.fold(
      (failure) => emit(TimetableError(failure.errorMessage)),
      (courseIds) => emit(CourseIdsSearched(courseIds)),
    );
  }
}
