import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniberry2/core/enums/update_comment_enum.dart';
import 'package:uniberry2/src/comment/domain/entities/comment.dart';
import 'package:uniberry2/src/comment/domain/usecases/create_comment.dart';
import 'package:uniberry2/src/comment/domain/usecases/delete_comment.dart';
import 'package:uniberry2/src/comment/domain/usecases/get_comments_by_post_id.dart';
import 'package:uniberry2/src/comment/domain/usecases/get_comments_by_user_id.dart';
import 'package:uniberry2/src/comment/domain/usecases/update_comment.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit({
    required CreateComment createComment,
    required GetCommentsByPostId getCommentsByPostId,
    required GetCommentsByUserId getCommentsByUserId,
    required UpdateComment updateComment,
    required DeleteComment deleteComment,
  })  : _createComment = createComment,
        _getCommentsByPostId = getCommentsByPostId,
        _getCommentsByUserId = getCommentsByUserId,
        _updateComment = updateComment,
        _deleteComment = deleteComment,
        super(CommentInitial());

  final CreateComment _createComment;
  final GetCommentsByPostId _getCommentsByPostId;
  final GetCommentsByUserId _getCommentsByUserId;
  final UpdateComment _updateComment;
  final DeleteComment _deleteComment;

  Future<void> createComment(Comment comment) async {
    emit(CommentLoading());
    final result = await _createComment(comment);
    result.fold(
      (failure) => emit(CommentError(failure.message)),
      (_) => emit(CommentCreated()),
    );
  }

  Future<void> getCommentsByPostId(String postId) async {
    emit(CommentLoading());
    final result = await _getCommentsByPostId(postId);
    result.fold(
      (failure) => emit(CommentError(failure.message)),
      (comments) => emit(CommentsFetched(comments)),
    );
  }

  Future<void> getCommentsByUserId(String userId) async {
    emit(CommentLoading());
    final result = await _getCommentsByUserId(userId);
    result.fold(
      (failure) => emit(CommentError(failure.message)),
      (comments) => emit(CommentsFetched(comments)),
    );
  }

  Future<void> updateComment({
    required String commentId,
    required UpdateCommentAction action,
    required dynamic commentData,
  }) async {
    emit(CommentLoading());
    final result = await _updateComment(UpdateCommentParams(
      commentId: commentId,
      action: action,
      commentData: commentData,
    ));
    result.fold(
      (failure) => emit(CommentError(failure.message)),
      (_) => emit(CommentUpdated()),
    );
  }

  Future<void> deleteComment(String commentId) async {
    emit(CommentLoading());
    final result = await _deleteComment(commentId);
    result.fold(
      (failure) => emit(CommentError(failure.message)),
      (_) => emit(CommentDeleted()),
    );
  }
}
