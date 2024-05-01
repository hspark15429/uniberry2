import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/core/errors/failures.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/domain/repository/timetable_repository.dart';
import 'package:uniberry2/src/timetable/domain/usecases/get_course.dart';

import 'timetable_repository.mock.dart';

void main() {
  late GetCourse usecase;
  late TimetableRepository repo;

  setUp(() {
    repo = MockTimetableRepo();
    usecase = GetCourse(repo);
  });

  String tCourseCode = '';
  ServerFailure tFailure =
      ServerFailure(message: 'message', statusCode: 'statusCode');

  test('should call [TimetableRepository.getCourse] and return [Course]',
      () async {
    // arrange
    when(() => repo.getCourse(any()))
        .thenAnswer((_) async => const Right(Course.empty()));
    // act
    final result = await usecase(tCourseCode);
    // assert
    expect(result, const Right(Course.empty()));
    verify(() => repo.getCourse(tCourseCode)).called(1);
    verifyNoMoreInteractions(repo);
  });

  test('should call [TimetableRepository.getCourse] and return failure',
      () async {
    // arrange
    when(() => repo.getCourse(any())).thenAnswer((_) async => Left(tFailure));

    // act
    final result = await usecase(tCourseCode);

    // assert
    expect(result, Left(tFailure));
    verify(() => repo.getCourse(tCourseCode)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
