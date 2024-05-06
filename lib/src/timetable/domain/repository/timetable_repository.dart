import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';

abstract class TimetableRepository {
  const TimetableRepository();

  // from firebase server
  ResultFuture<Timetable> getTimetable();

  // push new timetable to server.
  ResultFuture<void> updateTimetable(Timetable timetable);

  // get course from server using doc id
  ResultFuture<Course> getCourse(String courseId);

  // search course from server by keyword. Returns doc id's
  ResultFuture<List<String>> searchCourses({
    required String school,
    required String campus,
    required String term,
    required String period,
  });
}
