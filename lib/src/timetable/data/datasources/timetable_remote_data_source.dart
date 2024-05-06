import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';

abstract class TimetableRemoteDataSource {
  Future<CourseModel> getCourse(String courseId);
  Future<List<String>> searchCourses({
    required String school,
    required String campus,
    required String term,
    required String period,
  });
}

class TimetableRemoteDataSourceImpl implements TimetableRemoteDataSource {
  TimetableRemoteDataSourceImpl({required FirebaseFirestore cloudStoreClient})
      : _cloudStoreClient = cloudStoreClient;

  final FirebaseFirestore _cloudStoreClient;

  @override
  Future<CourseModel> getCourse(String courseId) async {
    try {
      var courseData = await _getCourseData(courseId);

      if (courseData.exists) {
        return CourseModel.fromMap(courseData.data()!);
      } else {
        throw const ServerException(
            message: 'course not found', statusCode: 'no-data');
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
      // Start with a base query
      Query<DataMap> query = _cloudStoreClient.collection('courses');

      // Conditionally add where clauses based on parameter values
      if (school.isNotEmpty) {
        query = query.where('schools', arrayContains: school);
      }
      if (campus.isNotEmpty) {
        query = query.where('campuses', arrayContains: campus);
      }
      if (term.isNotEmpty) {
        query = query.where('term', isEqualTo: term);
      }
      if (period.isNotEmpty) {
        query = query.where('periods', arrayContains: period);
      }
// Execute the query
      return await query.get().then((value) {
        return value.docs
            .map((course) => course.data()['courseId'] as String)
            .toList();
      });
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
