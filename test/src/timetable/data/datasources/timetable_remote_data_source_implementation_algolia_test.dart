import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source_implementation_algolia.dart';

void main() {
  late TimetableRemoteDataSource dataSource;
  const courseId = '0HR4deUwHMPeby0QpSH1';

  setUpAll(() async {
    final coursesSearcher = HitsSearcher(
      applicationID: 'K1COUI4FQ4',
      apiKey: '00383db0c4d34b63decf046026091f32',
      indexName: 'courses_index',
    );

    dataSource = TimetableRemoteDataSourceImplementationAlgolia(
      coursesSearcher: coursesSearcher,
    );
  });
  group('searchCourses', () {
    test('searchCourses success', () async {
      final result = await dataSource.searchCourses(
        school: '',
        campus: 'BKC',
        term: '',
        period: '',
      );
      expect(result, contains('0HR4deUwHMPeby0QpSH1'));
      expect(result, isNot(contains('X1F2Ki4i32RqntQojhp8')));

      // final result2 = await dataSource.searchCourses(
      //   school: '',
      //   campus: '',
      //   term: '夏集中Ⅳ(秋学期授与)',
      //   period: '',
      // );
      // expect(result2, contains('CFoo1BSMmuZ5FUb4LX7Q'));
      // expect(result2, isNot(contains('X1F2Ki4i32RqntQojhp8')));

      // final result3 = await dataSource.searchCourses(
      //   school: '',
      //   campus: 'OIC',
      //   term: '',
      //   period: '',
      // );

      // expect(
      //   result3,
      //   containsAll(['X1F2Ki4i32RqntQojhp8', 'XQznZnpWPtqWdsdOKMHe']),
      // );
      // expect(result3, isNot(contains('0HR4deUwHMPeby0QpSH1')));
    });
  });
}