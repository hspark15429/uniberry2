import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniberry2/core/enums/update_post_enum.dart';
import 'package:uniberry2/src/forum/data/models/post_model.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';
import 'package:uniberry2/src/forum/domain/usecases/create_post.dart';
import 'package:uniberry2/src/forum/domain/usecases/delete_post.dart';
import 'package:uniberry2/src/forum/domain/usecases/read_post.dart';
import 'package:uniberry2/src/forum/domain/usecases/update_post.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit({
    required CreatePost createPost,
    required ReadPost readPost,
    required UpdatePost updatePost,
    required DeletePost deletePost,
  })  : _createPost = createPost,
        _readPost = readPost,
        _updatePost = updatePost,
        _deletePost = deletePost,
        super(PostInitial());

  final CreatePost _createPost;
  final ReadPost _readPost;
  final UpdatePost _updatePost;
  final DeletePost _deletePost;

  Future<void> createPost({
    required String title,
    required String content,
    required String author,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) async {
    emit(PostLoading());
    final post = PostModel(
      postId: '',
      title: title,
      content: content,
      author: author,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
    final result = await _createPost(post);
    result.fold(
      (failure) => emit(PostError(failure.message)),
      (_) => emit(PostCreated()),
    );
  }

  Future<void> readPost(String postId) async {
    emit(PostLoading());
    final result = await _readPost(postId);

    result.fold(
      (failure) => emit(PostError(failure.message)),
      (post) => emit(PostRead(post)),
    );
  }

  Future<void> updatePost({
    required String postId,
    required UpdatePostAction action,
    required dynamic postData,
  }) async {
    emit(PostLoading());
    final result = await _updatePost(
      UpdatePostParams(
        postId: postId,
        action: action,
        postData: postData,
      ),
    );

    result.fold(
      (failure) => emit(PostError(failure.message)),
      (_) => emit(PostUpdated()),
    );
  }

  Future<void> deletePost(String postId) async {
    emit(PostLoading());
    final result = await _deletePost(postId);

    result.fold(
      (failure) => emit(PostError(failure.message)),
      (_) => emit(PostDeleted()),
    );
  }
}
