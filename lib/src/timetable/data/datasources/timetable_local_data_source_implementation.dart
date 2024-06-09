import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';
import 'package:uniberry2/src/timetable/data/models/timetable_model.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';

class TimetableLocalDataSourceImplementation
    implements TimetableRemoteDataSource {
  TimetableLocalDataSourceImplementation({required String jsonCourses})
      : _jsonCourses = jsonCourses;

  final String _jsonCourses;
  List<CourseModel> get _courses => (jsonDecode(_jsonCourses) as List<dynamic>)
      .map((e) => CourseModel.fromMap(e as DataMap))
      .toList();

  @override
  Future<CourseModel> getCourse(String courseId) async {
    try {
      final course =
          _courses.firstWhere((course) => course.courseId == courseId);
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
      final filteredCourses = _courses.where((course) {
        final matchesSchool = school.isEmpty || course.schools.contains(school);
        final matchesCampus =
            campus.isEmpty || course.campuses.contains(campus);
        final matchesTerm = term.isEmpty || course.term == term;
        final matchesPeriod = period.isEmpty || course.periods.contains(period);
        return matchesSchool && matchesCampus && matchesTerm && matchesPeriod;
      }).toList();

      return filteredCourses.map((e) => e.courseId).toList();
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
  Future<List<TimetableModel>> readTimetables() {
    // TODO: implement readTimetables
    throw UnimplementedError();
  }

  @override
  Future<void> updateTimetable(TimetableModel timetable) {
    // TODO: implement updateTimetable
    throw UnimplementedError();
  }
}
