import 'package:uniberry2/core/usecases/usecases.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/domain/repository/timetable_repository.dart';

class DeleteTimetable implements UsecaseWithParams<void, String> {
  const DeleteTimetable(this._repo);

  final TimetableRepository _repo;

  @override
  ResultFuture<void> call(String timetableId) async {
    return _repo.deleteTimetable(timetableId);
  }
}
