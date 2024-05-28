import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/domain/usecases/get_course.dart';
import 'package:uniberry2/src/timetable/domain/usecases/search_courses.dart';

part 'timetable_state.dart';

class TimetableCubit extends Cubit<TimetableState> {
  final GetCourse _getCourse;
  final SearchCourses _searchCourses;
  final List<String> _schools = [
    "法学部",
    "経済学部",
    "経営学部",
    // 다른 학부 추가
  ];

  final Map<String, Map<String, Course?>> _semesterTimetables = {}; // 학기별 시간표 저장
  final List<String> _timetables = []; // 시간표 목록 추가

  String? _selectedSchool; // 선택된 학부 상태

  // 설정 관련 상태 초기값
  int _periods = 5;
  bool _includeSaturday = false;
  bool _includeSunday = false;

  TimetableCubit({
    required GetCourse getCourse,
    required SearchCourses searchCourses,
  })  : _getCourse = getCourse,
        _searchCourses = searchCourses,
        super(TimetableInitial()) {
    // 초기 상태로 TimetableUpdated 방출
    _emitTimetableUpdated();
  }

  List<String> get schools => _schools;
  Map<String, Map<String, Course?>> get semesterTimetables => _semesterTimetables;
  List<String> get timetables => _timetables; // 시간표 목록 getter 추가

  String? get selectedSchool => _selectedSchool; // 선택된 학부를 외부에서 가져올 수 있게 getter 추가

  void setSelectedSchool(String school) {
    _selectedSchool = school; // 선택된 학부 설정
    emit(SchoolSelected(_selectedSchool)); // 선택된 학부 상태 업데이트
  }

  void setSemester(String semester) {
    if (!_semesterTimetables.containsKey(semester)) {
      _semesterTimetables[semester] = {};
    }
    emit(SemesterSelected(
      selectedSchool: _selectedSchool,
      semester: semester,
    ));
  }

  void addCourseToTimetable(Course course, String period, String semester) {
    final timetable = _semesterTimetables[semester] ?? {};
    timetable[period] = course;
    _semesterTimetables[semester] = timetable;
    emit(CoursesUpdated(Map.from(timetable)));
    _emitTimetableUpdated();
  }

  void removeCourseFromTimetable(String period, String semester) {
    final timetable = _semesterTimetables[semester];
    if (timetable != null) {
      timetable.remove(period);
      emit(CoursesUpdated(Map.from(timetable)));
    }
    _emitTimetableUpdated();
  }

  void addTimetable(String timetable) {
    _timetables.add(timetable);
    emit(TimetableUpdated(
      periods: _periods,
      includeSaturday: _includeSaturday,
      includeSunday: _includeSunday,
      timetables: List.from(_timetables),
    ));
  }

  void removeTimetable(String timetable) {
    _timetables.remove(timetable);
    emit(TimetableUpdated(
      periods: _periods,
      includeSaturday: _includeSaturday,
      includeSunday: _includeSunday,
      timetables: List.from(_timetables),
    ));
  }

  Future<void> getCourse(String courseId) async {
    emit(TimetableLoading());
    final course = await _getCourse(courseId);
    course.fold(
      (failure) => emit(TimetableError(failure.errorMessage)),
      (course) => emit(CourseFetched(course)),
    );
    _emitTimetableUpdated();
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
    _emitTimetableUpdated();
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
    (courseIds) async {
      if (courseIds.isNotEmpty) {
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
        } else {
          emit(CoursesFetched(validCourses));
        }
      } else {
        emit(const CoursesFetched([]));
      }
    },
  );
  _emitTimetableUpdated();
}

  void setPeriods(int periods) {
    _periods = periods;
    _emitTimetableUpdated();
  }

  void setIncludeSaturday(bool include) {
    _includeSaturday = include;
    _emitTimetableUpdated();
  }

  void setIncludeSunday(bool include) {
    _includeSunday = include;
    _emitTimetableUpdated();
  }

  int get periods => _periods;
  bool get includeSaturday => _includeSaturday;
  bool get includeSunday => _includeSunday;

  void loadMoreCourses() {}

  void _emitTimetableUpdated() {
    emit(TimetableUpdated(
      periods: _periods,
      includeSaturday: _includeSaturday,
      includeSunday: _includeSunday,
      timetables: List.from(_timetables), // 시간표 목록 포함
    ));
  }
}
