import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  late CourseModel tCourse;
  late DataMap tDataMap;

  setUp(() {
    tCourse = const CourseModel(
      code: '80128',
      title: '研究実践Ⅰ (D)',
      professor: '谷垣 和則',
    );
    tDataMap = jsonDecode(fixture('course.json')) as DataMap;
  });

  test('should be a subclass of Course entity', () {
    // assert
    expect(tCourse, isA<Course>());
  });

  test('fromMap', () {
    // act
    final result = CourseModel.fromMap(tDataMap);
    // assert
    expect(result, tCourse);
  });

  test('toMap', () {
    // act
    final result = tCourse.toMap();
    // assert
    expect(result, tDataMap);
  });

  test('copyWith', () {
    // act
    final result = tCourse.copyWith();
    // assert
    expect(result, tCourse);
  });
}
