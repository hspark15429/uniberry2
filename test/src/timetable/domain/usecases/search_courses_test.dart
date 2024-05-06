import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/src/timetable/domain/repository/timetable_repository.dart';
import 'package:uniberry2/src/timetable/domain/usecases/search_courses.dart';

import 'timetable_repository.mock.dart';

void main() {
  late SearchCourses usecase;
  late TimetableRepository repo;

  SearchCoursesParams tParams = const SearchCoursesParams.empty();

  setUp(() {
    repo = MockTimetableRepo();
    usecase = SearchCourses(repo);
    registerFallbackValue(tParams);
  });

  const tCourseIds = ['DaEBpyYgtZsiqXEJrB1m', 'HfriePN36BDqAFS6GbVw'];

  test(
      'should call [TimetableRepository.searchCourses] '
      'and return List<String> of codes', () async {
    // arrange
    when(() => repo.searchCourses(
          campus: any(named: 'campus'),
          period: any(named: 'period'),
          school: any(named: 'school'),
          term: any(named: 'term'),
        )).thenAnswer((_) async => const Right(tCourseIds));
    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Right(tCourseIds));
    verify(() => repo.searchCourses(
          campus: tParams.campus!,
          period: tParams.period!,
          school: tParams.school!,
          term: tParams.term!,
        )).called(1);
    verifyNoMoreInteractions(repo);
  });
}
