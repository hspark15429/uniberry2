import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/data/models/post_model.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final timestampData = {
    '_seconds': 1677483548,
    '_nanoseconds': 123456000,
  };
  final date = DateTime.fromMillisecondsSinceEpoch(
    timestampData['_seconds']!,
  ).add(
    Duration(
      microseconds: timestampData['_nanoseconds']!,
    ),
  );
  final timestamp = Timestamp.fromDate(date);

  final tPost = PostModel.empty(timestamp.toDate());
  late DataMap tDataMap;

  setUp(() {
    tDataMap = jsonDecode(fixture('post.json')) as DataMap;
    tDataMap['createdAt'] = timestamp;
    tDataMap['updatedAt'] = timestamp;
  });

  test('should be a subclass of Post entity', () {
    // assert
    expect(tPost, isA<Post>());
  });

  test('fromMap', () {
    // act
    final result = PostModel.fromMap(tDataMap);
    // assert
    expect(result, tPost);
  });

  test('toMap', () {
    // act
    final result = tPost.toMap()
      ..remove('createdAt')
      ..remove('updatedAt');

    // assert
    expect(
        result,
        tDataMap
          ..remove('createdAt')
          ..remove('updatedAt'),);
  });

  test('copyWith', () {
    // act
    final result = tPost.copyWith(postId: '2');
    // assert
    expect(result.postId, '2');
  });
}
