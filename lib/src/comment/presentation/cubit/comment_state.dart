part of 'comment_cubit.dart';

sealed class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

final class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentCreated extends CommentState {}

class CommentsFetchedByPostId extends CommentState {
  const CommentsFetchedByPostId(this.comments);

  final List<Comment> comments;

  @override
  List<Object> get props => [comments];
}

class CommentUpdated extends CommentState {}

class CommentDeleted extends CommentState {}

class CommentError extends CommentState {
  const CommentError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
