import 'package:equatable/equatable.dart';

class Timetable extends Equatable {
  const Timetable({required this.timetable});

  final Map<int, String> timetable;

  @override
  List<Object?> get props => [timetable];
}
