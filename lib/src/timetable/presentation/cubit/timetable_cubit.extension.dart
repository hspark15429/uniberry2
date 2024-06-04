part of 'timetable_cubit.dart';

extension TimetableCubitExtension on TimetableCubit {
  void setSelectedSchool(String school) {
    _selectedSchool = school; // 선택된 학부 설정
    emit(SchoolSelected(_selectedSchool)); // 선택된 학부 상태 업데이트
  }

  // Unused code
  // void setSemester(String semester) {
  //   if (!_semesterTimetables.containsKey(semester)) {
  //     _semesterTimetables[semester] = {};
  //   }
  //   emit(SemesterSelected(
  //     selectedSchool: _selectedSchool,
  //     semester: semester,
  //   ));
  // }

  void addCourseToTimetable(Course course, String period, String semester) {
    final timetable = _semesterTimetables[semester] ?? {};
    timetable[period] = course;
    _semesterTimetables[semester] = timetable;
    emit(CoursesUpdated(Map.from(timetable)));
    _emitTimetableUpdated();
  }

  void removeCourseFromTimetable(String period, String semester) {
    final timetable = _semesterTimetables[semester];
    if (timetable != null) {
      timetable.remove(period);
      emit(CoursesUpdated(Map.from(timetable)));
    }
    _emitTimetableUpdated();
  }

  void addTimetable(String timetable) {
    _timetables.add(timetable);
    // 새로운 시간표를 추가할 때 _semesterTimetables에도 추가
    _semesterTimetables[timetable] = {};
    _emitTimetableUpdated();
  }

  void removeTimetable(String timetable) {
    _timetables.remove(timetable);
    _semesterTimetables.remove(timetable); // 시간표 제거 시 _semesterTimetables에서도 제거
    _emitTimetableUpdated();
  }

  void updateTimetable(String oldName, String newName) {
    final index = _timetables.indexOf(oldName);
    if (index != -1) {
      _timetables[index] = newName;

      // _semesterTimetables 키 업데이트
      _semesterTimetables[newName] = _semesterTimetables.remove(oldName)!;

      _emitTimetableUpdated();
    }
  }

  void setPeriods(int periods) {
    _periods = periods;
    _emitTimetableUpdated();
  }

  void setIncludeSaturday(bool include) {
    _includeSaturday = include;
    _emitTimetableUpdated();
  }

  void setIncludeSunday(bool include) {
    _includeSunday = include;
    _emitTimetableUpdated();
  }

  void loadMoreCourses() {}

  void _emitTimetableUpdated() {
    emit(TimetableUpdated(
      periods: _periods,
      includeSaturday: _includeSaturday,
      includeSunday: _includeSunday,
      timetables: List.from(_timetables), // 시간표 목록 포함
    ));
  }
}
