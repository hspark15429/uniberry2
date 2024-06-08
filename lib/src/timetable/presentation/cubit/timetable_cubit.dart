library timetable_cubit;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/domain/usecases/get_course.dart';
import 'package:uniberry2/src/timetable/domain/usecases/search_courses.dart';

part 'timetable_cubit.extension.dart';
part 'timetable_state.dart';
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
      "産業社会学部",
      "国際関係学部",
      "政策科学部",
      "文学部",
      "映像学部",
      "総合心理学部",
      "理工学部",
      "グローバル教養学部",
      "食マネジメント学部",
      "情報理工学部",
      "生命科学部",
      "薬学部",
      "スポーツ健康科学部",
      "法学研究科",
      "経済学研究科",
      "経営学研究科",
      "社会学研究科",
      "国際関係研究科",
      "政策科学研究科",
      "文学研究科",
      "映像研究科",
      "理工学研究科",
      "情報理工学研究科",
      "生命科学研究科",
      "薬学研究科",
      "スポーツ健康科学研究科",
      "応用人間科学研究科",
      "先端総合学術研究科",
      "言語教育情報研究科",
      "法務研究科",
      "テクノロジー・マネジメント研究科",
      "経営管理研究科",
      "公務研究科",
      "教職研究科",
      "人間科学研究科",
      "食マネジメント研究科",

    // 다른 학부 추가
  ];
  List<String> get schools => _schools;

  ///
  ///
  ///
  /// cubit.extension을 위한 변수들 선언
  // 학기별 시간표 저장
  final Map<String, Map<String, Course?>> _semesterTimetables = {};
  Map<String, Map<String, Course?>> get semesterTimetables =>
      _semesterTimetables;

  final List<String> _timetables = []; // 시간표 목록 추가
  List<String> get timetables => _timetables; // 시간표 목록 getter 추가

  String? _selectedSchool; // 선택된 학부 상태
  String? get selectedSchool => _selectedSchool;

  // 설정 관련 상태 초기값
  int _periods = 5;
  bool _includeSaturday = false;
  bool _includeSunday = false;
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
