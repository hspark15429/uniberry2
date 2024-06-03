import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/src/forum/domain/repository/post_repository.dart';
import 'package:uniberry2/src/forum/domain/usecases/delete_post.dart';

import 'post_repository.mock.dart';

void main() {
  late PostRepository repo;
  late DeletePost usecase;
  setUp(() {
    repo = MockPostRepository();
    usecase = DeletePost(repo);
  });

  test('should delete post from the repository', () async {
    // arrange
    when(() => repo.deletePost(any()))
        .thenAnswer((_) async => const Right(null));
    // act
    final result = await usecase('postId');
    // assert
    expect(result, const Right<dynamic, void>(null));
    verify(() => repo.deletePost('postId')).called(1);
    verifyNoMoreInteractions(repo);
  });
}
