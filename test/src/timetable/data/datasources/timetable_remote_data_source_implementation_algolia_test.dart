import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source_implementation_algolia.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';

void main() {
  late TimetableRemoteDataSource dataSource;
  const courseId = '1OQuA2lK7sZJBsnhYZ0j';

  const tCourse = CourseModel.empty();

  setUpAll(() async {
    await dotenv.load();

    final coursesSearcher = HitsSearcher(
      applicationID: dotenv.env['ALGOLIA_APP_ID']!,
      apiKey: dotenv.env['ALGOLIA_API_KEY']!,
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
      // expect(result, contains('0HR4deUwHMPeby0QpSH1'));
      // expect(result, isNot(contains('X1F2Ki4i32RqntQojhp8')));

      final result2 = await dataSource.searchCourses(
        school: '',
        campus: '',
        term: '夏集中Ⅳ(秋学期授与)',
        period: '',
      );
      // expect(result2, contains('CFoo1BSMmuZ5FUb4LX7Q'));
      // expect(result2, isNot(contains('X1F2Ki4i32RqntQojhp8')));

      final result3 = await dataSource.searchCourses(
        school: '',
        campus: 'OIC',
        term: '',
        period: '',
      );

      // expect(
      //   result3,
      //   containsAll(['X1F2Ki4i32RqntQojhp8', 'XQznZnpWPtqWdsdOKMHe']),
      // );
      // expect(result3, isNot(contains('0HR4deUwHMPeby0QpSH1')));
    });
  });
  group('getCourse', () {
    // test('getCourse success', () async {
    //   var result = await dataSource.getCourse(courseId);
    //   debugPrint(result.toString());
    //   // expect(result, tCourse.copyWith(courseId: courseId));
    // });
    test('getCourse fail', () async {
      final methodCall = dataSource.getCourse;
      expect(
        methodCall('sss'),
        throwsA(
          const ServerException(
            message: 'course not found',
            statusCode: 'no-data',
          ),
        ),
      );
    });
  });
}
