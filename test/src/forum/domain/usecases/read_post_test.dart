import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';
import 'package:uniberry2/src/forum/domain/repository/post_repository.dart';
import 'package:uniberry2/src/forum/domain/usecases/read_post.dart';

import 'repository.mock.dart';

void main() {
  late ReadPost usecase;
  late PostRepository repo;
  final tPost = Post.empty();

  setUp(() {
    repo = MockPostRepository();
    usecase = ReadPost(repo);
  });

  test('should call [PostRepository.readPost] and return Right(Post)',
      () async {
    // arrange
    when(() => repo.readPost(any())).thenAnswer((_) async => Right(tPost));
    // act
    final result = await usecase('_empty.postId');
    // assert
    expect(result, Right<dynamic, Post>(tPost));
    verify(() => repo.readPost('_empty.postId')).called(1);
    verifyNoMoreInteractions(repo);
  });
}
