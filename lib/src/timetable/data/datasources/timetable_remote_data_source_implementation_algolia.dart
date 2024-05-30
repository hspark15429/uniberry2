import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';

class TimetableRemoteDataSourceImplementationAlgolia
    implements TimetableRemoteDataSource {
  TimetableRemoteDataSourceImplementationAlgolia(
      {required HitsSearcher coursesSearcher})
      : _coursesSearcher = coursesSearcher;

  final HitsSearcher _coursesSearcher;
  Stream<HitsPage> get _searchPage =>
      _coursesSearcher.responses.map(HitsPage.fromResponse);

  @override
  Future<CourseModel> getCourse(String courseId) {
    // TODO: implement getCourse
    throw UnimplementedError();
  }

  @override
  Future<List<String>> searchCourses(
      {required String school,
      required String campus,
      required String term,
      required String period}) async {
    // TODO: implement searchCourses

    _coursesSearcher.applyState(
      (state) => state.copyWith(
        query: '',
        page: 0,
        hitsPerPage: 200,
        facetFilters: ['campuses:$campus'],
      ),
    );

    final results = await _searchPage.first;
    final courseNames = results.items.map((course) => course.courseId).toList();

    return courseNames;
  }
}

class HitsPage {
  const HitsPage(this.items, this.pageKey, this.nextPageKey);

  final List<CourseModel> items;
  final int pageKey;
  final int? nextPageKey;

  factory HitsPage.fromResponse(SearchResponse response) {
    final items = response.hits.map(CourseModel.fromJson).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsPage(items, response.page, nextPageKey);
  }
}
