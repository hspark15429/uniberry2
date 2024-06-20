import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:typesense/typesense.dart';
import 'package:uniberry/core/errors/exceptions.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry/src/timetable/data/models/course_model.dart';
import 'package:uniberry/src/timetable/data/models/timetable_model.dart';
import 'package:uniberry/src/timetable/domain/entities/timetable.dart';

class TimetableRemoteDataSourceImplementationTypesense
    implements TimetableRemoteDataSource {
  TimetableRemoteDataSourceImplementationTypesense({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
    required Client typesenseClient,
  })  : _typesenseClient = typesenseClient,
        _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;
  final Client _typesenseClient;

  @override
  Future<CourseModel> getCourse(String courseId) async {
    try {
      final searchParameters = {
        'q': courseId,
        'query_by': 'courseId',
      };

      final results = await _typesenseClient
          .collection('courses')
          .documents
          .search(searchParameters);

      if (results['found'] == 0) {
        // debugPrint('course not found');
        debugPrint(courseId);
        throw const ServerException(
          message: 'course not found',
          statusCode: 'no-data',
        );
      } else if (results['found'] as int > 1) {
        throw const ServerException(
          message: 'multiple courses found',
          statusCode: 'multiple-data',
        );
      }
      final course = CourseModel.fromMap(
        ((results['hits'] as List).first as DataMap)['document'] as DataMap,
      );

      return course;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<List<String>> searchCourses({
    required String query,
    required String school,
    required String campus,
    required String term,
    required String period,
  }) async {
    try {
      // Build the filterBy string dynamically
      final filters = [];
      if (campus.isNotEmpty) filters.add('campuses:$campus');
      if (period.isNotEmpty) filters.add('periods:$period*');
      if (term.isNotEmpty) filters.add('term:$term');
      if (school.isNotEmpty) filters.add('schools:$school');

      final filterString = filters.isNotEmpty ? filters.join(' && ') : '';

      final searchParameters = {
        'q': query,
        'query_by': 'codes',
        'filter_by': filterString,
        'include_fields': 'courseId',
        'per_page': '100',
        'group_by': 'codes',
        'group_limit': '1',
      };

      final results = await _typesenseClient
          .collection('courses')
          .documents
          .search(searchParameters);

      if (results['found'] == 0) {
        throw const ServerException(
          message: 'course not found',
          statusCode: 'no-data',
        );
      }
      final courseIds = <String>[];

      for (final (groupedHit as DataMap)
          in results['grouped_hits'] as Iterable) {
        for (final (hit as DataMap) in groupedHit['hits'] as Iterable) {
          courseIds.add((hit['document'] as DataMap)['courseId'] as String);
        }
      }
      return courseIds;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> createTimetable(Timetable timetable) async {
    try {
      final docReference = await _cloudStoreClient.collection('timetables').add(
            (timetable as TimetableModel).toMap(),
          );

      await _cloudStoreClient
          .collection('timetables')
          .doc(docReference.id)
          .update(
        {
          'timetableId': docReference.id,
          'uid': _authClient.currentUser!.uid,
        },
      );

      await _cloudStoreClient
          .collection('users')
          .doc(_authClient.currentUser!.uid)
          .update(
        {
          'timetableIds': FieldValue.arrayUnion([docReference.id]),
        },
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint(e.toString());
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<TimetableModel> readTimetable(String timetableId) async {
    try {
      return await _cloudStoreClient
          .collection('timetables')
          .doc(timetableId)
          .get()
          .then(
            (value) => TimetableModel.fromMap(value.data()!),
          );
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint(s.toString());
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> updateTimetable({
    required String timetableId,
    required Timetable timetable,
  }) async {
    try {
      return _cloudStoreClient.collection('timetables').doc(timetableId).update(
            (timetable as TimetableModel).toMap(),
          );
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint(s.toString());
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> deleteTimetable(String timetableId) async {
    try {
      await _cloudStoreClient
          .collection('timetables')
          .doc(timetableId)
          .delete();

      await _cloudStoreClient
          .collection('users')
          .doc(_authClient.currentUser!.uid)
          .update(
        {
          'timetableIds': FieldValue.arrayRemove([timetableId]),
        },
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint(s.toString());
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }
}
