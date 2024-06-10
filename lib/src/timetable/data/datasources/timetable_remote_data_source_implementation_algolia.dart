import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';
import 'package:uniberry2/src/timetable/data/models/timetable_model.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';

class TimetableRemoteDataSourceImplementationAlgolia
    implements TimetableRemoteDataSource {
  TimetableRemoteDataSourceImplementationAlgolia(
      {required HitsSearcher coursesSearcher})
      : _coursesSearcher = coursesSearcher;

  final HitsSearcher _coursesSearcher;
  Stream<HitsPage> get _searchPage =>
      _coursesSearcher.responses.map(HitsPage.fromResponse);

  @override
  Future<CourseModel> getCourse(String courseId) async {
    try {
      _coursesSearcher.query(courseId);

      final results = await _searchPage.first;
      if (results.items.isEmpty) {
        throw const ServerException(
          message: 'course not found',
          statusCode: 'no-data',
        );
      } else if (results.items.length > 1) {
        throw const ServerException(
          message: 'Multiple courses found',
          statusCode: '500',
        );
      }
      final course = results.items.first;
      return course;
    } on ServerException {
      rethrow;
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
      _coursesSearcher.applyState(
        (state) => state.copyWith(
          query: '',
          page: 0,
          hitsPerPage: 150,
          facetFilters: [
            'campuses:$campus',
            'term:$term',
            'periods:$period',
            'schools:$school',
          ],
        ),
      );

      final results = await _searchPage.first;
      final courseIds = results.items.map((course) => course.courseId).toList();

      return courseIds;
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

class HitsPage {
  const HitsPage(this.items, this.pageKey, this.nextPageKey);

  factory HitsPage.fromResponse(SearchResponse response) {
    final items = response.hits.map(CourseModel.fromJson).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsPage(items, response.page, nextPageKey);
  }

  final List<CourseModel> items;
  final int pageKey;
  final int? nextPageKey;
}
