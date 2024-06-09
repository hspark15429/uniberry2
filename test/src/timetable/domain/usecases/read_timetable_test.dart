import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';
import 'package:uniberry2/src/timetable/domain/repository/timetable_repository.dart';
import 'package:uniberry2/src/timetable/domain/usecases/read_timetable.dart';

import 'timetable_repository.mock.dart';

void main() {
  late ReadTimetable usecase;
  late TimetableRepository repo;

  final tTimetable = Timetable.empty();

  setUp(() {
    repo = MockTimetableRepo();
    usecase = ReadTimetable(repo);
  });

  test(
      'should call [TimetableRepository.readTimetable] and '
      'return Right(Timetable)', () async {
    // arrange
    when(() => repo.readTimetable(any()))
        .thenAnswer((_) async => Right(tTimetable));
    // act
    final result = await usecase('_empty.timetableId');
    // assert
    expect(result, Right<dynamic, Timetable>(tTimetable));
    verify(() => repo.readTimetable('_empty.timetableId')).called(1);
    verifyNoMoreInteractions(repo);
  });
}
