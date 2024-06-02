import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/data/models/post_model.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  late PostModel tPost;
  late DataMap tDataMap;

  setUp(() {
    tPost = const PostModel.empty();
    tPost = tPost.copyWith(
      postId: '1',
      title: 'random post',
      content: 'haha funny',
      author: 'anon',
      createdAt: '2023',
      updatedAt: '2024',
    );
    tDataMap = jsonDecode(fixture('post.json')) as DataMap;
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
    final result = tPost.toMap();
    // assert
    expect(result, tDataMap);
  });

  test('copyWith', () {
    // act
    final result = tPost.copyWith(postId: '2');
    // assert
    expect(result.postId, '2');
  });
}
