import 'package:uniberry2/core/usecases/usecases.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/domain/repository/timetable_repository.dart';

class GetCourse implements UsecaseWithParams<Course, String> {
  const GetCourse(this._repo);

  final TimetableRepository _repo;

  @override
  ResultFuture<Course> call(String code) async {
    final course = await _repo.getCourse(code);
    return course;
  }
}
