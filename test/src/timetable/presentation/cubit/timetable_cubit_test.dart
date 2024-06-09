import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';
import 'package:uniberry2/src/timetable/domain/usecases/create_timetable.dart';
import 'package:uniberry2/src/timetable/domain/usecases/get_course.dart';
import 'package:uniberry2/src/timetable/domain/usecases/search_courses.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';

class MockGetCourse extends Mock implements GetCourse {}

class MockSearchCourses extends Mock implements SearchCourses {}

class MockCreateTimetable extends Mock implements CreateTimetable {}

void main() {
  late GetCourse getCourse;
  late SearchCourses searchCourses;
  late CreateTimetable createTimetable;
  late TimetableCubit cubit;

  setUp(() {
    getCourse = MockGetCourse();
    searchCourses = MockSearchCourses();
    createTimetable = MockCreateTimetable();
    cubit = TimetableCubit(
      getCourse: getCourse,
      searchCourses: searchCourses,
      createTimetable: createTimetable,
    );

    registerFallbackValue(const SearchCoursesParams.empty());
    registerFallbackValue(Timetable.empty());
  });

  const Course tCourse = CourseModel.empty();
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
}
