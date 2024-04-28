import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';

part 'timetable_state.dart';

class TimetableCubit extends Cubit<TimetableState> {
  TimetableCubit() : super(TimetableInitial());
}
