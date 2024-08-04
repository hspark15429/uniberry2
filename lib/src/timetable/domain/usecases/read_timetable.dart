import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/timetable/domain/entities/timetable.dart';
import 'package:uniberry/src/timetable/domain/repository/timetable_repository.dart';

class ReadTimetable implements UsecaseWithParams<Timetable, String> {
  const ReadTimetable(this._repo);

  final TimetableRepository _repo;

  @override
  ResultFuture<Timetable> call(String timetableId) async {
    return _repo.readTimetable(timetableId);
  }
}
