import 'package:uniberry2/core/enums/update_comment_enum.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/data/datasources/comment_remote_data_source.dart';
import 'package:uniberry2/src/forum/domain/entities/comment.dart';
import 'package:uniberry2/src/forum/domain/repository/comment_repository.dart';

class CommentRepositoryImplementation implements CommentRepository {
  CommentRepositoryImplementation(this._remoteDataSource);

  final CommentRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> createComment(Comment comment) async {
    // TODO: implement createComment
    throw UnimplementedError();
  }

  @override
  ResultFuture<void> deleteComment(String commentId) async {
    // TODO: implement deleteComment
    throw UnimplementedError();
  }

  @override
  ResultFuture<List<Comment>> getCommentsByPostId(String postId) async {
    // TODO: implement getCommentsByPostId
    throw UnimplementedError();
  }

  @override
  ResultFuture<void> updateComment(
      {required String commentId,
      required UpdateCommentAction action,
      required commentData,}) async {
    // TODO: implement updateComment
    throw UnimplementedError();
  }
}
