import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/domain/usecases/get_course.dart';
import 'package:uniberry2/src/timetable/domain/usecases/search_courses.dart';

part 'timetable_state.dart';

class TimetableCubit extends Cubit<TimetableState> {
  List<Course> timetableCourses = [];
  final GetCourse _getCourse;
  final SearchCourses _searchCourses;
  final List<String> _schools = [
    "法学部",
    "経済学部",
    "経営学部",
    // 다른 학부 추가
  ];

  String? _selectedSchool; // 선택된 학부 상태

  TimetableCubit({
    required GetCourse getCourse,
    required SearchCourses searchCourses,
  })  : _getCourse = getCourse,
        _searchCourses = searchCourses,
        super(TimetableInitial());

  List<String> get schools => _schools;

  String? get selectedSchool => _selectedSchool; // 선택된 학부를 외부에서 가져올 수 있게 getter 추가

  void setSelectedSchool(String school) {
    _selectedSchool = school; // 선택된 학부 설정
    emit(SchoolSelected(_selectedSchool)); // 선택된 학부 상태 업데이트
  }

  void addCourseToTimetable(Course course) {
    timetableCourses.add(course); // 강의 추가
    emit(CoursesUpdated(timetableCourses)); // 시간표 업데이트 이벤트 발생
  }

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
      school: _selectedSchool ?? school,
      campus: campus,
      term: term,
      period: period,
    ));

    courseIds.fold(
      (failure) => emit(TimetableError(failure.errorMessage)),
      (courseIds) {
        if (courseIds.isNotEmpty) {
            getCourses(courseIds);
        } else {
            emit(CoursesFetched([]));
        }
    });
}


  void loadMoreCourses() {}
}


