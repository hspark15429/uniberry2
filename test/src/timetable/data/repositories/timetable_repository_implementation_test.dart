import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/core/errors/failures.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';
import 'package:uniberry2/src/timetable/data/repositories/timetable_repository_implementation.dart';

class MockTimetableRemoteDataSource extends Mock
    implements TimetableRemoteDataSource {}

void main() {
  late TimetableRemoteDataSource remoteDataSource;
  late TimetableRepositoryImplementation repo;

  setUp(() {
    remoteDataSource = MockTimetableRemoteDataSource();
    repo = TimetableRepositoryImplementation(remoteDataSource);
  });

  // Test for [getCourse] success
  test(
      'should call [remoteDataSource.getCourse] '
      'and return success', () async {
    // arrange
    when(() => remoteDataSource.getCourse(any())).thenAnswer(
      (_) async => const CourseModel(
        code: '80128',
        title: '研究実践Ⅰ (D)',
        professor: '谷垣 和則',
      ),
    );

    // act
    final result = await repo.getCourse('80128');

    // assert
    expect(
        result,
        const Right(CourseModel(
          code: '80128',
          title: '研究実践Ⅰ (D)',
          professor: '谷垣 和則',
        )));

    verify(() => remoteDataSource.getCourse('80128')).called(1);
    verifyNoMoreInteractions(remoteDataSource);
  });

  // Test for [getCourse] failure
  test(
      'should call [remoteDataSource.getCourse] '
      'and return failure', () async {
    // arrange
    when(() => remoteDataSource.getCourse(any()))
        .thenThrow(const ServerException(
      message: 'some.message',
      statusCode: 'some.code',
    ));

    // act
    final result = await repo.getCourse('80128');

    // assert
    expect(result,
        Left(ServerFailure(message: 'some.message', statusCode: 'some.code')));
    verify(() => remoteDataSource.getCourse('80128')).called(1);
    verifyNoMoreInteractions(remoteDataSource);
  });
}
