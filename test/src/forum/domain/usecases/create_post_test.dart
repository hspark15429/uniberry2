import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry/src/forum/domain/entities/post.dart';
import 'package:uniberry/src/forum/domain/repository/post_repository.dart';
import 'package:uniberry/src/forum/domain/usecases/create_post.dart';

import 'repository.mock.dart';

void main() {
  late CreatePost usecase;
  late PostRepository repo;

  final tPost = Post.empty();

  setUp(() {
    repo = MockPostRepository();
    usecase = CreatePost(repo);
    registerFallbackValue(tPost);
  });

  test('should call [PostRepository.createPost] and return Right(null)',
      () async {
    // arrange
    when(() => repo.createPost(any()))
        .thenAnswer((_) async => const Right(null));
    // act
    final result = await usecase(tPost);
    // assert
    expect(result, const Right<dynamic, void>(null));
    verify(() => repo.createPost(tPost)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
