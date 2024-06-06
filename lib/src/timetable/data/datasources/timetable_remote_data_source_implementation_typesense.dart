import 'package:flutter/foundation.dart';
import 'package:typesense/typesense.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';

class TimetableRemoteDataSourceImplementationTypesense
    implements TimetableRemoteDataSource {
  TimetableRemoteDataSourceImplementationTypesense({
    required Client typesenseClient,
  }) : _typesenseClient = typesenseClient;
  final Client _typesenseClient;

  @override
  Future<CourseModel> getCourse(String courseId) async {
    try {
      final searchParameters = {
        'q': '$courseId',
        'query_by': 'courseId',
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
    required String school,
    required String campus,
    required String term,
    required String period,
  }) async {
    try {
      // Build the filterBy string dynamically
      final filters = [];
      if (campus.isNotEmpty) filters.add('campuses:$campus');
      if (period.isNotEmpty) filters.add('periods:$period');
      if (term.isNotEmpty) filters.add('term:$term');
      if (school.isNotEmpty) filters.add('schools:$school');

      final filterString = filters.isNotEmpty ? filters.join(' && ') : '';

      final searchParameters = {
        'q': '',
        'query_by': 'periods,term,campuses,schools,codes',
        'filter_by': filterString,
        'include_fields': 'courseId',
        'per_page': '25',
        'group_by': 'codes',
        'group_limit': '1'
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

      debugPrint(courseIds.toString());
      return courseIds;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
