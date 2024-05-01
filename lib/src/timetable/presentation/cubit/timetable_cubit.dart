import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';
import 'package:uniberry2/src/timetable/domain/usecases/get_course.dart';

part 'timetable_state.dart';

class TimetableCubit extends Cubit<TimetableState> {
  TimetableCubit({required GetCourse getCourse})
      : _getCourse = getCourse,
        super(TimetableInitial());

  final GetCourse _getCourse;

  Future<void> getCourse(String courseId) async {
    emit(TimetableLoading());
    final course = await _getCourse(courseId);
    course.fold(
      (failure) => emit(TimetableError(failure.message)),
      (course) => emit(CourseFetched(course)),
    );
  }
}
