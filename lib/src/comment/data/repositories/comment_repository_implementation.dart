import 'package:dartz/dartz.dart';
import 'package:uniberry2/core/enums/update_comment_enum.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/core/errors/failures.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/comment/data/datasources/comment_remote_data_source.dart';
import 'package:uniberry2/src/comment/domain/entities/comment.dart';
import 'package:uniberry2/src/comment/domain/repository/comment_repository.dart';

class CommentRepositoryImplementation implements CommentRepository {
  CommentRepositoryImplementation(this._remoteDataSource);

  final CommentRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> createComment(Comment comment) async {
    try {
      final result = await _remoteDataSource.createComment(comment);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> deleteComment(String commentId) async {
    try {
      final result = await _remoteDataSource.deleteComment(commentId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<Comment>> getCommentsByPostId(String postId) async {
    try {
      final result = await _remoteDataSource.getCommentsByPostId(postId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> updateComment({
    required String commentId,
    required UpdateCommentAction action,
    required dynamic commentData,
  }) async {
    try {
      final result = await _remoteDataSource.updateComment(
        commentId: commentId,
        action: action,
        commentData: commentData,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
