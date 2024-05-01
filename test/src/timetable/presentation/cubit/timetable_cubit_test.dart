import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/domain/usecases/get_course.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';

class MockGetCourse extends Mock implements GetCourse {}

void main() {
  late GetCourse getCourse;
  late TimetableCubit cubit;

  setUp(() {
    getCourse = MockGetCourse();
    cubit = TimetableCubit(getCourse: getCourse);
  });

  Course tCourse = const CourseModel.empty();

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
            .thenAnswer((_) async => Right(tCourse));
        return cubit;
      },
      act: (cubit) => cubit.getCourse('code'),
      expect: () => [TimetableLoading(), CourseFetched(tCourse)],
      verify: (_) {
        verify(() => getCourse('code')).called(1);
        verifyNoMoreInteractions(getCourse);
      },
    );
  });
}
