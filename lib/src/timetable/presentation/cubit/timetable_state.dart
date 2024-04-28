part of 'timetable_cubit.dart';

sealed class TimetableState extends Equatable {
  const TimetableState();

  @override
  List<Object> get props => [];
}

final class TimetableInitial extends TimetableState {}

class TimetableLoading extends TimetableState {}

class TimetableLoaded extends TimetableState {
  const TimetableLoaded(this.timetable);

  final Timetable timetable;

  @override
  List<Object> get props => [timetable];
}
