import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/timetable/domain/entities/course.dart';
import 'package:uniberry/src/timetable/domain/entities/timetable.dart';

abstract class TimetableRepository {
  const TimetableRepository();

  // get course from server using doc id
  ResultFuture<Course> getCourse(String courseId);

  // search course from server by keyword. Returns doc id's
  ResultFuture<List<String>> searchCourses({
    required String query,
    required String school,
    required String campus,
    required String term,
    required String period,
  });

  // create new timetable
  ResultFuture<void> createTimetable(Timetable timetable);

  // from firebase server
  ResultFuture<Timetable> readTimetable(String timetableId);

  // push new timetable to server.
  ResultFuture<void> updateTimetable({
    required String timetableId,
    required Timetable timetable,
  });

  ResultFuture<void> deleteTimetable(String timetableId);
}
