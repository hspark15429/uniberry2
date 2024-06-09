import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/data/models/timetable_model.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  late TimetableModel tTimetable;
  late DataMap tDataMap;

  setUp(() {
    tTimetable = TimetableModel.empty();
    tDataMap = jsonDecode(fixture('timetable.json')) as DataMap;
  });

  test('should be a subclass of Timetable entity', () {
    // assert
    expect(tTimetable, isA<Timetable>());
  });

  test('fromMap', () {
    // act
    final result = TimetableModel.fromMap(tDataMap);
    // assert
    expect(result.name, tTimetable.name);
    expect(mapEquals(result.timetableMap, tTimetable.timetableMap), isTrue);
  });

  test('toMap', () {
    // act
    final result = tTimetable.toMap();
    // assert
    expect(result, tDataMap);
  });

  test('copyWith', () {
    // act
    final result = tTimetable.copyWith(name: 'new name');
    // assert
    expect(result.name, 'new name');
  });
}
