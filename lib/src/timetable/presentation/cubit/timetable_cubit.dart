library timetable_cubit;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';
import 'package:uniberry2/src/timetable/domain/usecases/create_timetable.dart';
import 'package:uniberry2/src/timetable/domain/usecases/delete_timetable.dart';
import 'package:uniberry2/src/timetable/domain/usecases/get_course.dart';
import 'package:uniberry2/src/timetable/domain/usecases/read_timetable.dart';
import 'package:uniberry2/src/timetable/domain/usecases/search_courses.dart';
import 'package:uniberry2/src/timetable/domain/usecases/update_timetable.dart';

part 'timetable_cubit.extension.dart';
part 'timetable_state.dart';
part 'timetable_state.extension.dart';

class TimetableCubit extends Cubit<TimetableState> {
  TimetableCubit({
    required GetCourse getCourse,
    required SearchCourses searchCourses,
    required CreateTimetable createTimetable,
    required ReadTimetable readTimetable,
    required UpdateTimetable updateTimetable,
    required DeleteTimetable deleteTimetable,
  })  : _getCourse = getCourse,
        _searchCourses = searchCourses,
        _createTimetable = createTimetable,
        _readTimetable = readTimetable,
        _updateTimetable = updateTimetable,
        _deleteTimetable = deleteTimetable,
        super(TimetableInitial());

  final GetCourse _getCourse;
  final SearchCourses _searchCourses;
  final CreateTimetable _createTimetable;
  final ReadTimetable _readTimetable;
  final UpdateTimetable _updateTimetable;
  final DeleteTimetable _deleteTimetable;

  final List<String> _schools = [
    '法学部',
    '経済学部',
    '経営学部',
    '産業社会学部',
    '国際関係学部',
    '政策科学部',
    '文学部',
    '映像学部',
    '総合心理学部',
    '理工学部',
    'グローバル教養学部',
    '食マネジメント学部',
    '情報理工学部',
    '生命科学部',
    '薬学部',
    'スポーツ健康科学部',
    '法学研究科',
    '経済学研究科',
    '経営学研究科',
    '社会学研究科',
    '国際関係研究科',
    '政策科学研究科',
    '文学研究科',
    '映像研究科',
    '理工学研究科',
    '情報理工学研究科',
    '生命科学研究科',
    '薬学研究科',
    'スポーツ健康科学研究科',
    '応用人間科学研究科',
    '先端総合学術研究科',
    '言語教育情報研究科',
    '法務研究科',
    'テクノロジー・マネジメント研究科',
    '経営管理研究科',
    '公務研究科',
    '教職研究科',
    '人間科学研究科',
    '食マネジメント研究科',

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
    emit(const TimetableLoading());
    final course = await _getCourse(courseId);
    course.fold(
      (failure) => emit(TimetableError(failure.errorMessage)),
      (course) => emit(CourseFetched(course)),
    );
  }

  Future<void> getCourses(List<String> courseIds) async {
    emit(const TimetableLoading());

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
    emit(const TimetableLoading());

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

  Future<void> createTimetable(Timetable timetable) async {
    emit(const TimetableLoading());
    final result = await _createTimetable(timetable);
    result.fold(
      (failure) => emit(TimetableError(failure.errorMessage)),
      (_) => emit(const TimetableCreated()),
    );
  }

  Future<void> readTimetable(String timetableId) async {
    emit(const TimetableLoading());
    final result = await _readTimetable(timetableId);
    result.fold(
      (failure) => emit(TimetableError(failure.errorMessage)),
      (timetable) => emit(TimetableRead(timetable)),
    );
  }

  Future<void> updateTimetable({
    required String timetableId,
    required Timetable timetable,
  }) async {
    emit(const TimetableLoading());
    final result = await _updateTimetable(
      UpdateTimetableParams(
        timetableId: timetableId,
        timetable: timetable,
      ),
    );
    result.fold(
      (failure) => emit(TimetableError(failure.errorMessage)),
      (_) => emit(const TimetableUpdateCompleted()),
    );
  }

  Future<void> deleteTimetable(String timetableId) async {
    emit(const TimetableLoading());
    final result = await _deleteTimetable(timetableId);
    result.fold(
      (failure) => emit(TimetableError(failure.errorMessage)),
      (_) => emit(const TimetableDeleted()),
    );
  }

  Future<void> getTimetables(List<String> timetableIds) async {
    emit(const TimetableLoading());

    final timetables = <Timetable>[];
    for (final timetableId in timetableIds) {
      final result = await _readTimetable(timetableId);
      final timetable = result.fold(
        (failure) => TimetableError(failure.errorMessage),
        timetables.add,
      );
    }

    if (timetables.isEmpty) {
      emit(const TimetableError('No courses found'));
      return;
    }
    emit(TimetablesFetched(timetables));
  }
}
