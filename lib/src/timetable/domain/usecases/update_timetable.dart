import 'package:equatable/equatable.dart';
import 'package:uniberry2/core/usecases/usecases.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';
import 'package:uniberry2/src/timetable/domain/repository/timetable_repository.dart';

class UpdateTimetable
    implements UsecaseWithParams<void, UpdateTimetableParams> {
  const UpdateTimetable(this.repository);

  final TimetableRepository repository;

  @override
  ResultFuture<void> call(UpdateTimetableParams params) async {
    return repository.updateTimetable(
      timetableId: params.timetableId,
      timetable: params.timetable,
    );
  }
}

class UpdateTimetableParams extends Equatable {
  const UpdateTimetableParams({
    required this.timetableId,
    required this.timetable,
  });

  UpdateTimetableParams.empty()
      : this(
          timetableId: 'empty.timetableId',
          timetable: Timetable.empty(),
        );

  final String timetableId;
  final Timetable timetable;

  @override
  List<Object?> get props => [timetableId, timetable];
}
