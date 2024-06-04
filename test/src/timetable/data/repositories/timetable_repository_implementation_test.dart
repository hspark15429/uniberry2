import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/core/errors/failures.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';
import 'package:uniberry2/src/timetable/data/repositories/timetable_repository_implementation.dart';
import 'package:uniberry2/src/timetable/domain/usecases/search_courses.dart';

class MockTimetableRemoteDataSource extends Mock
    implements TimetableRemoteDataSource {}

void main() {
  late TimetableRemoteDataSource remoteDataSource;
  late TimetableRepositoryImplementation repo;

  setUp(() {
    remoteDataSource = MockTimetableRemoteDataSource();
    repo = TimetableRepositoryImplementation(remoteDataSource);
  });

  const tCourseIds = ['DaEBpyYgtZsiqXEJrB1m', 'HfriePN36BDqAFS6GbVw'];
  const tSearchCoursesParams = SearchCoursesParams.empty();
  const tCourseModel = CourseModel.empty();

  group('getCourse', () {
    // Test for [getCourse] success
    test(
        'should call [remoteDataSource.getCourse] '
        'and return success', () async {
      // arrange
      when(() => remoteDataSource.getCourse(any()))
          .thenAnswer((_) async => tCourseModel);

      // act
      final result = await repo.getCourse('80128');

      // assert
      expect(result, const Right(tCourseModel));

      verify(() => remoteDataSource.getCourse('80128')).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    // Test for [getCourse] failure
    test(
        'should call [remoteDataSource.getCourse] '
        'and return failure', () async {
      // arrange
      when(() => remoteDataSource.getCourse(any())).thenThrow(
        const ServerException(
          message: 'some.message',
          statusCode: 'some.code',
        ),
      );

      // act
      final result = await repo.getCourse('80128');

      // assert
      expect(
        result,
        Left(
          ServerFailure(message: 'some.message', statusCode: 'some.code'),
        ),
      );
      verify(() => remoteDataSource.getCourse('80128')).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('searchCourses', () {
    test('should call [remoteDataSource.searchCourses]', () async {
      when(
        () => remoteDataSource.searchCourses(
          campus: any(named: 'campus'),
          period: any(named: 'period'),
          school: any(named: 'school'),
          term: any(named: 'term'),
        ),
      ).thenAnswer((_) async => tCourseIds);

      final result = await repo.searchCourses(
        campus: tSearchCoursesParams.campus!,
        period: tSearchCoursesParams.period!,
        school: tSearchCoursesParams.school!,
        term: tSearchCoursesParams.term!,
      );

      expect(result, const Right(tCourseIds));
      verify(
        () => remoteDataSource.searchCourses(
          campus: tSearchCoursesParams.campus!,
          period: tSearchCoursesParams.period!,
          school: tSearchCoursesParams.school!,
          term: tSearchCoursesParams.term!,
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return [ServerFailure] when [remoteDataSource.searchCourses] fails',
        () async {
      when(
        () => remoteDataSource.searchCourses(
          campus: any(named: 'campus'),
          period: any(named: 'period'),
          school: any(named: 'school'),
          term: any(named: 'term'),
        ),
      ).thenThrow(
        const ServerException(
          message: 'some.message',
          statusCode: 'some.code',
        ),
      );

      final result = await repo.searchCourses(
        campus: tSearchCoursesParams.campus!,
        period: tSearchCoursesParams.period!,
        school: tSearchCoursesParams.school!,
        term: tSearchCoursesParams.term!,
      );

      expect(
        result,
        Left(
          ServerFailure(message: 'some.message', statusCode: 'some.code'),
        ),
      );
      verify(
        () => remoteDataSource.searchCourses(
          campus: tSearchCoursesParams.campus!,
          period: tSearchCoursesParams.period!,
          school: tSearchCoursesParams.school!,
          term: tSearchCoursesParams.term!,
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
