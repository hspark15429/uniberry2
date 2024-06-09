import 'package:uniberry2/src/timetable/data/models/course_model.dart';
import 'package:uniberry2/src/timetable/data/models/timetable_model.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';

abstract class TimetableRemoteDataSource {
  Future<CourseModel> getCourse(String courseId);
  Future<List<String>> searchCourses({
    required String school,
    required String campus,
    required String term,
    required String period,
  });

  Future<void> createTimetable(Timetable timetable);
  Future<List<TimetableModel>> readTimetables();
  Future<void> updateTimetable(TimetableModel timetable);
  Future<void> deleteTimetable(String name);
}
