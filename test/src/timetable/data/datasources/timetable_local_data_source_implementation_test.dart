import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_local_data_source_implementation.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  late TimetableRemoteDataSource dataSource;
  late String jsonCourses;
  const courseId = '43dcc2c1152443b3880efa5fe55636dc';

  const tCourse = CourseModel.empty();

  setUpAll(() async {
    // jsonCourses = await rootBundle.loadString('tools/courses.json');
jsonCourses = fixture('courses2.json');
    dataSource =
        TimetableLocalDataSourceImplementation(jsonCourses: jsonCourses);
  });
  group('searchCourses', () {
    test('searchCourses success', () async {
      final result = await dataSource.searchCourses(
        school: '',
        campus: '',
        term: '',
        period: '月1',
      );
      expect(result, contains('1b2ff5ef71a148b39eea40d626325ab3'));
      expect(result, isNot(contains('e070a3c3d1e64355a80e82f9b9fcf304')));

      final result2 = await dataSource.searchCourses(
        school: '',
        campus: '',
        term: '夏集中Ⅳ(秋学期授与)',
        period: '',
      );
      expect(result2, contains('43dcc2c1152443b3880efa5fe55636dc'));
      expect(result2, isNot(contains('1b2ff5ef71a148b39eea40d626325ab3')));

      final result3 = await dataSource.searchCourses(
        school: '',
        campus: 'OIC',
        term: '',
        period: '',
      );

      expect(
        result3,
        containsAll([
          '444d049c28b54985bfe46756f2cbd901',
          'c6356be42ea84c158e358c9fa1c914fd'
        ]),
      );
      expect(result3, isNot(contains('cd1e8d3e74924aa1970daffd5249ebbb')));
    });
  });
  group('getCourse', () {
    test('getCourse success', () async {
      var result = await dataSource.getCourse(courseId);
      debugPrint(result.toString());
      expect(result, tCourse.copyWith(courseId: courseId));
    });
    test('getCourse fail', () async {
      final methodCall = dataSource.getCourse;
      expect(
        methodCall('sss'),
        throwsA(
          const ServerException(
            message: 'Bad state: No element',
            statusCode: '505',
          ),
        ),
      );
    });
  });
}
