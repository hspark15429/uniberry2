import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';

abstract class TimetableRemoteDataSource {
  Future<CourseModel> getCourse(String courseId);
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
}
