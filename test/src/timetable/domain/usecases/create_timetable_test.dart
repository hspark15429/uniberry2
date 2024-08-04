import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry/src/timetable/domain/entities/timetable.dart';
import 'package:uniberry/src/timetable/domain/repository/timetable_repository.dart';
import 'package:uniberry/src/timetable/domain/usecases/create_timetable.dart';

import 'timetable_repository.mock.dart';

void main() {
  late CreateTimetable usecase;
  late TimetableRepository repo;

  final tTimetable = Timetable.empty();

  setUp(() {
    repo = MockTimetableRepo();
    usecase = CreateTimetable(repo);
    registerFallbackValue(tTimetable);
  });

  test(
      'should call [TimetableRepository.createTimetable] and return Right(null)',
      () async {
    // arrange
    when(() => repo.createTimetable(any()))
        .thenAnswer((_) async => const Right(null));
    // act
    final result = await usecase(tTimetable);
    // assert
    expect(result, const Right<dynamic, void>(null));
    verify(() => repo.createTimetable(tTimetable)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
