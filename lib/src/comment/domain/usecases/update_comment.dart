import 'package:equatable/equatable.dart';
import 'package:uniberry/core/enums/update_comment_enum.dart';
import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/comment/domain/repository/comment_repository.dart';

class UpdateComment implements UsecaseWithParams<void, UpdateCommentParams> {
  final CommentRepository repository;

  UpdateComment(this.repository);

  @override
  ResultFuture<void> call(UpdateCommentParams params) async {
    return repository.updateComment(
      commentId: params.commentId,
      action: params.action,
      commentData: params.commentData,
    );
  }
}

class UpdateCommentParams extends Equatable {
  const UpdateCommentParams({
    required this.commentId,
    required this.action,
    required this.commentData,
  });

  const UpdateCommentParams.empty()
      : commentId = '',
        action = UpdateCommentAction.like,
        commentData = '';

  final String commentId;
  final UpdateCommentAction action;
  final dynamic commentData;

  @override
  List<Object?> get props => [action, commentData];
}
