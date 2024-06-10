import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';
import 'package:uniberry2/src/timetable/domain/usecases/create_timetable.dart';
import 'package:uniberry2/src/timetable/domain/usecases/delete_timetable.dart';
import 'package:uniberry2/src/timetable/domain/usecases/get_course.dart';
import 'package:uniberry2/src/timetable/domain/usecases/read_timetable.dart';
import 'package:uniberry2/src/timetable/domain/usecases/search_courses.dart';
import 'package:uniberry2/src/timetable/domain/usecases/update_timetable.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';

class MockGetCourse extends Mock implements GetCourse {}

class MockSearchCourses extends Mock implements SearchCourses {}

class MockCreateTimetable extends Mock implements CreateTimetable {}

class MockReadTimetable extends Mock implements ReadTimetable {}

class MockUpdateTimetable extends Mock implements UpdateTimetable {}

class MockDeleteTimetable extends Mock implements DeleteTimetable {}

void main() {
  late GetCourse getCourse;
  late SearchCourses searchCourses;
  late CreateTimetable createTimetable;
  late ReadTimetable readTimetable;
  late UpdateTimetable updateTimetable;
  late DeleteTimetable deleteTimetable;
  late TimetableCubit cubit;

  setUp(() {
    getCourse = MockGetCourse();
    searchCourses = MockSearchCourses();
    createTimetable = MockCreateTimetable();
    readTimetable = MockReadTimetable();
    updateTimetable = MockUpdateTimetable();
    deleteTimetable = MockDeleteTimetable();

    cubit = TimetableCubit(
      getCourse: getCourse,
      searchCourses: searchCourses,
      createTimetable: createTimetable,
      readTimetable: readTimetable,
      updateTimetable: updateTimetable,
      deleteTimetable: deleteTimetable,
    );

    registerFallbackValue(const SearchCoursesParams.empty());
    registerFallbackValue(Timetable.empty());
    registerFallbackValue(UpdateTimetableParams.empty());
  });

  const Course tCourse = CourseModel.empty();
  const String tTimetableId = 'timetableId';
  final Timetable tTimetable = Timetable.empty();

  test('check the initial state', () async {
    expect(cubit.state, TimetableInitial());
  });

  tearDown(() {
    cubit.close();
  });

  group('getCourse', () {
    blocTest<TimetableCubit, TimetableState>(
      'emits [TimetableLoading, CourseFetched] when successful',
      build: () {
        when(() => getCourse.call(any()))
            .thenAnswer((_) async => const Right(tCourse));
        return cubit;
      },
      act: (cubit) => cubit.getCourse('code'),
      expect: () => [TimetableLoading(), const CourseFetched(tCourse)],
      verify: (_) {
        verify(() => getCourse('code')).called(1);
        verifyNoMoreInteractions(getCourse);
      },
    );
  });

  group('searchCourses', () {
    blocTest<TimetableCubit, TimetableState>(
      'emits [TimetableLoading, CourseIdsSearched] when successful',
      build: () {
        when(() => searchCourses(any()))
            .thenAnswer((_) async => const Right(['code']));
        return cubit;
      },
      act: (cubit) => cubit.searchCourses(school: 'Engineering'),
      expect: () => [
        TimetableLoading(),
        const CourseIdsSearched(['code']),
      ],
      verify: (_) {
        verify(
          () => searchCourses(const SearchCoursesParams(school: 'Engineering')),
        ).called(1);
        verifyNoMoreInteractions(searchCourses);
      },
    );
  });

  group('getCourses', () {
    blocTest<TimetableCubit, TimetableState>(
      'emits [TimetableLoading, CoursesFetched] when successful',
      build: () {
        when(() => getCourse.call(any()))
            .thenAnswer((_) async => const Right(tCourse));
        return cubit;
      },
      act: (cubit) => cubit.getCourses(['code1', 'code2', 'code3']),
      expect: () => [
        TimetableLoading(),
        const CoursesFetched([tCourse, tCourse, tCourse]),
      ],
      verify: (_) {
        verify(() => getCourse('code1')).called(1);
        verify(() => getCourse('code2')).called(1);
        verify(() => getCourse('code3')).called(1);
        verifyNoMoreInteractions(getCourse);
      },
    );
  });

  group('createTimetable', () {
    blocTest<TimetableCubit, TimetableState>(
      'emits [TimetableLoading, TimetableCreated] when successful',
      build: () {
        when(() => createTimetable.call(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.createTimetable(tTimetable),
      expect: () => [const TimetableLoading(), const TimetableCreated()],
      verify: (_) {
        verify(() => createTimetable(tTimetable)).called(1);
        verifyNoMoreInteractions(createTimetable);
      },
    );
  });

  group('readTimetable', () {
    blocTest<TimetableCubit, TimetableState>(
      'emits [TimetableLoading, TimetableRead] when successful',
      build: () {
        when(() => readTimetable.call(any()))
            .thenAnswer((_) async => Right(tTimetable));
        return cubit;
      },
      act: (cubit) => cubit.readTimetable(tTimetableId),
      expect: () => [TimetableLoading(), TimetableRead(tTimetable)],
      verify: (_) {
        verify(() => readTimetable(tTimetableId)).called(1);
        verifyNoMoreInteractions(readTimetable);
      },
    );
  });

  group('updateTimetable', () {
    blocTest<TimetableCubit, TimetableState>(
      'emits [TimetableLoading, TimetableUpdated] when successful',
      build: () {
        when(() => updateTimetable.call(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.updateTimetable(
        timetableId: tTimetableId,
        timetable: tTimetable,
      ),
      expect: () => [
        const TimetableLoading(),
        const TimetableUpdateCompleted(),
      ],
      verify: (_) {
        verify(
          () => updateTimetable(
            UpdateTimetableParams(
              timetableId: tTimetableId,
              timetable: tTimetable,
            ),
          ),
        ).called(1);
        verifyNoMoreInteractions(updateTimetable);
      },
    );
  });

  group('deleteTimetable', () {
    blocTest<TimetableCubit, TimetableState>(
      'emits [TimetableLoading, TimetableDeleted] when successful',
      build: () {
        when(() => deleteTimetable.call(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.deleteTimetable(tTimetableId),
      expect: () => [const TimetableLoading(), const TimetableDeleted()],
      verify: (_) {
        verify(() => deleteTimetable(tTimetableId)).called(1);
        verifyNoMoreInteractions(deleteTimetable);
      },
    );
  });
}
