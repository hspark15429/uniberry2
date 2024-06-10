import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';
import 'package:uniberry2/src/timetable/data/models/timetable_model.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';

class TimetableRemoteDataSourceImplementation
    implements TimetableRemoteDataSource {
  TimetableRemoteDataSourceImplementation({
    required FirebaseFirestore cloudStoreClient,
  }) : _cloudStoreClient = cloudStoreClient;

  final FirebaseFirestore _cloudStoreClient;

  @override
  Future<CourseModel> getCourse(String courseId) async {
    try {
      final courseData = await _getCourseData(courseId);

      if (courseData.exists) {
        return CourseModel.fromMap(courseData.data()!);
      } else {
        throw const ServerException(
          message: 'course not found',
          statusCode: 'no-data',
        );
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  Future<DocumentSnapshot<DataMap>> _getCourseData(String courseId) async {
    return _cloudStoreClient.collection('courses').doc(courseId).get();
  }

  @override
  Future<List<String>> searchCourses({
    required String school,
    required String campus,
    required String term,
    required String period,
  }) async {
    try {
      // Start with a base query on the most selective array field
      Query<DataMap> query = _cloudStoreClient.collection('courses');

      // Apply the first arrayContains (choose the one you expect to filter down results the most)
      if (school.isNotEmpty) {
        query = query.where('schools', arrayContains: school);
      }

      // Execute the initial query
      final results = await query.get();
      final filteredResults = results.docs
          .where((doc) {
            final matchesCampus = campus.isEmpty ||
                (doc.data()['campuses'] as List).contains(campus);
            final matchesTerm = term.isEmpty || doc.data()['term'] == term;
            final matchesPeriod = period.isEmpty ||
                (doc.data()['periods'] as List).contains(period);
            return matchesCampus && matchesTerm && matchesPeriod;
          })
          .map((doc) => doc.data()['courseId'] as String)
          .toList();

      return filteredResults;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> createTimetable(Timetable timetable) {
    // TODO: implement createTimetable
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTimetable(String name) {
    // TODO: implement deleteTimetable
    throw UnimplementedError();
  }

  @override
  Future<TimetableModel> readTimetable(String timetableId) {
    // TODO: implement readTimetables
    throw UnimplementedError();
  }

  @override
  Future<void> updateTimetable({
    required String timetableId,
    required Timetable timetable,
  }) {
    // TODO: implement updateTimetable
    throw UnimplementedError();
  }
}
