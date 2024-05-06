import 'package:dartz/dartz.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/core/errors/failures.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';
import 'package:uniberry2/src/timetable/domain/repository/timetable_repository.dart';

class TimetableRepositoryImplementation implements TimetableRepository {
  TimetableRepositoryImplementation(this._remoteDataSource);

  final TimetableRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<Course> getCourse(String courseId) async {
    try {
      final result = await _remoteDataSource.getCourse(courseId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<Timetable> getTimetable() async {
    // TODO: implement getTimetable
    throw UnimplementedError();
  }

  @override
  ResultFuture<List<String>> searchCourses({
    required String school,
    required String campus,
    required String term,
    required String period,
  }) async {
    try {
      final result = await _remoteDataSource.searchCourses(
        campus: campus,
        period: period,
        school: school,
        term: term,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> updateTimetable(Timetable timetable) async {
    // TODO: implement updateTimetable
    throw UnimplementedError();
  }
}
