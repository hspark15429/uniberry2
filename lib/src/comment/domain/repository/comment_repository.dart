import 'package:uniberry2/core/enums/update_comment_enum.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/comment/domain/entities/comment.dart';

abstract class CommentRepository {
  const CommentRepository();

  ResultFuture<void> createComment(Comment comment);
  ResultFuture<List<Comment>> getCommentsByPostId(String postId);
  ResultFuture<List<Comment>> getCommentsByUserId(String userId);
  ResultFuture<void> updateComment({
    required String commentId,
    required UpdateCommentAction action,
    required dynamic commentData,
  });
  ResultFuture<void> deleteComment(String commentId);
}
