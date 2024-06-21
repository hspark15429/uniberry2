import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry/core/enums/update_post_enum.dart';
import 'package:uniberry/src/forum/domain/repository/post_repository.dart';
import 'package:uniberry/src/forum/domain/usecases/update_post.dart';

import 'repository.mock.dart';

void main() {
  late PostRepository repo;
  late UpdatePost usecase;

  setUp(() {
    repo = MockPostRepository();
    usecase = UpdatePost(repo);
    registerFallbackValue(UpdatePostAction.title);
  });

  test('should call [PostRepository.updatePost]', () async {
    // arrange
    when(
      () => repo.updatePost(
        postId: any(named: 'postId'),
        action: any(named: 'action'),
        postData: any<dynamic>(named: 'postData'),
      ),
    ).thenAnswer((_) async => const Right(null));
    // act
    final result = await usecase(
      const UpdatePostParams(
        postId: 'some id',
        action: UpdatePostAction.title,
        postData: 'new title',
      ),
    );
    // assert
    expect(result, const Right<dynamic, void>(null));
    verify(
      () => repo.updatePost(
        postId: 'some id',
        action: UpdatePostAction.title,
        postData: 'new title',
      ),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
