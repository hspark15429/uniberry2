part of 'post_cubit.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

final class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostCreated extends PostState {}

class PostRead extends PostState {
  const PostRead(this.post);

  final Post post;

  @override
  List<Object> get props => [post];
}

class PostUpdated extends PostState {}

class PostDeleted extends PostState {}

class PostError extends PostState {
  const PostError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
