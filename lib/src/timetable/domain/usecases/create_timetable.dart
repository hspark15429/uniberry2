import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/timetable/domain/entities/timetable.dart';
import 'package:uniberry/src/timetable/domain/repository/timetable_repository.dart';

class CreateTimetable implements UsecaseWithParams<void, Timetable> {
  const CreateTimetable(this._repo);

  final TimetableRepository _repo;

  @override
  ResultFuture<void> call(Timetable timetable) async {
    return _repo.createTimetable(timetable);
  }
}
