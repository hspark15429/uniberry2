import 'package:uniberry2/core/enums/update_comment_enum.dart';
import 'package:uniberry2/src/forum/domain/entities/comment.dart';

abstract class CommentRemoteDataSource {
  const CommentRemoteDataSource();
  Future<void> createComment(Comment comment);
  // Future<CommentModel> readComment(String commentId);
  Future<void> updateComment({
    required String commentId,
    required UpdateCommentAction action,
    required dynamic commentData,
  });
  Future<void> deleteComment(String commentId);

  Future<List<String>> searchComments({
    required String author,
    required String content,
  });
}
