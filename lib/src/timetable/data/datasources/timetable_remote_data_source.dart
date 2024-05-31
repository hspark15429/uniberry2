import 'package:uniberry2/src/timetable/data/models/course_model.dart';

abstract class TimetableRemoteDataSource {
  Future<CourseModel> getCourse(String courseId);
  Future<List<String>> searchCourses({
    required String school,
    required String campus,
    required String term,
    required String period,
  });
}
