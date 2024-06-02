import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniberry2/src/forum/data/models/post_model.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';
import 'package:uniberry2/src/forum/domain/usecases/create_post.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit({
    required CreatePost createPost,
  })  : _createPost = createPost,
        super(PostInitial());

  final CreatePost _createPost;

  Future<void> createPost(
    String title,
    String content,
    String author,
    String createdAt,
    String updatedAt,
  ) async {
    emit(CreatingPost());
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
}
