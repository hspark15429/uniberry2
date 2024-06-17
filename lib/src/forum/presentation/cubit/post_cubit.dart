import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniberry2/core/enums/update_post_enum.dart';
import 'package:uniberry2/src/forum/data/models/post_model.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';
import 'package:uniberry2/src/forum/domain/repository/post_repository.dart';
import 'package:uniberry2/src/forum/domain/usecases/create_post.dart';
import 'package:uniberry2/src/forum/domain/usecases/delete_post.dart';
import 'package:uniberry2/src/forum/domain/usecases/read_post.dart';
import 'package:uniberry2/src/forum/domain/usecases/read_posts.dart';
import 'package:uniberry2/src/forum/domain/usecases/search_posts.dart';
import 'package:uniberry2/src/forum/domain/usecases/search_posts_with_page_key.dart';
import 'package:uniberry2/src/forum/domain/usecases/update_post.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit({
    required CreatePost createPost,
    required ReadPost readPost,
    required ReadPosts readPosts,
    required UpdatePost updatePost,
    required DeletePost deletePost,
    required SearchPosts searchPosts,
    required SearchPostsWithPageKey searchPostsWithPageKey,
  })  : _createPost = createPost,
        _readPost = readPost,
        _readPosts = readPosts,
        _updatePost = updatePost,
        _deletePost = deletePost,
        _searchPosts = searchPosts,
        _searchPostsWithPageKey = searchPostsWithPageKey,
        super(PostInitial());

  final CreatePost _createPost;
  final ReadPost _readPost;
  final ReadPosts _readPosts;
  final UpdatePost _updatePost;
  final DeletePost _deletePost;
  final SearchPosts _searchPosts;
  final SearchPostsWithPageKey _searchPostsWithPageKey;

  Future<void> createPost({
    required String title,
    required String content,
    required String author,
    required DateTime createdAt,
    required DateTime updatedAt,
    List<String> tags = const [],
  }) async {
    emit(PostLoading());
    final post = PostModel(
      postId: '',
      title: title,
      content: content,
      author: author,
      createdAt: createdAt,
      updatedAt: updatedAt,
      tags: tags,
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

  Future<void> readPosts(List<String> postIds) async {
    emit(PostLoading());
    final result = await _readPosts(postIds);

    result.fold(
      (failure) => emit(PostError(failure.message)),
      (posts) => emit(PostsRead(posts)),
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

  Future<void> searchPosts(String query) async {
    emit(PostLoading());
    final result = await _searchPosts(
      SearchPostsParams(
        title: '',
        content: query,
        author: '',
      ),
    );

    result.fold(
      (failure) => emit(PostError(failure.message)),
      (postIds) => emit(PostsSearched(postIds)),
    );
  }

  Future<void> searchPostsWithPageKey({
    required String query,
    required int pageKey,
  }) async {
    // emit(PostLoading());
    final result = await _searchPostsWithPageKey(
      SearchPostsWithPageKeyParams(
        title: '',
        content: query,
        author: '',
        pageKey: pageKey,
      ),
    );
    result.fold(
      (failure) => emit(PostError(failure.message)),
      (searchResult) => emit(PostsSearchedWithPagekey(searchResult)),
    );
  }
}
