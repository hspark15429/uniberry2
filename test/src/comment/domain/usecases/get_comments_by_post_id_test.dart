import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry/src/comment/domain/entities/comment.dart';
import 'package:uniberry/src/comment/domain/repository/comment_repository.dart';
import 'package:uniberry/src/comment/domain/usecases/get_comments_by_post_id.dart';

import 'repository.mock.dart';

void main() {
  late GetCommentsByPostId usecase;
  late CommentRepository repo;
  final tComment = Comment.empty();

  setUp(() {
    repo = MockCommentRepository();
    usecase = GetCommentsByPostId(repo);
  });

  test(
      'should call [CommentRepository.getCommentsByPostId] '
      'and return Right(List<Comment>)', () async {
    // arrange
    when(() => repo.getCommentsByPostId(any()))
        .thenAnswer((_) async => Right([tComment]));
    final deepEquality = const DeepCollectionEquality().equals;
    // act

    // assert
    final result = await usecase('_empty.postId');
    expect(result.isRight(), true);
    result.fold(
      (l) => fail('Expected a Right value'),
      (r) {
        expect(deepEquality(r, [tComment]), true);
      },
    );

    verify(() => repo.getCommentsByPostId('_empty.postId')).called(1);
    verifyNoMoreInteractions(repo);
  });
}
