import 'package:uniberry2/core/enums/update_comment_enum.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/domain/entities/comment.dart';

abstract class CommentRepository {
  const CommentRepository();

  ResultFuture<void> createComment(Comment comment);
  ResultFuture<List<Comment>> getCommentsByPostId(String postId);
  ResultFuture<void> updateComment({
    required String commentId,
    required UpdateCommentAction action,
    required dynamic commentData,
  });
  ResultFuture<void> deleteComment(String commentId);
}
