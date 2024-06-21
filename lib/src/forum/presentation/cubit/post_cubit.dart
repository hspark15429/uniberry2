import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniberry/core/enums/update_post_enum.dart';
import 'package:uniberry/src/forum/data/models/post_model.dart';
import 'package:uniberry/src/forum/domain/entities/post.dart';
import 'package:uniberry/src/forum/domain/repository/post_repository.dart';
import 'package:uniberry/src/forum/domain/usecases/create_post.dart';
import 'package:uniberry/src/forum/domain/usecases/create_post_with_image.dart';
import 'package:uniberry/src/forum/domain/usecases/delete_post.dart';
import 'package:uniberry/src/forum/domain/usecases/get_posts_by_user_id.dart';
import 'package:uniberry/src/forum/domain/usecases/read_post.dart';
import 'package:uniberry/src/forum/domain/usecases/read_posts.dart';
import 'package:uniberry/src/forum/domain/usecases/search_posts.dart';
import 'package:uniberry/src/forum/domain/usecases/search_posts_with_page_key.dart';
import 'package:uniberry/src/forum/domain/usecases/update_post.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit({
    required CreatePost createPost,
    required CreatePostWithImage createPostWithImage,
    required ReadPost readPost,
    required ReadPosts readPosts,
    required GetPostsByUserId getPostsByUserId,
    required UpdatePost updatePost,
    required DeletePost deletePost,
    required SearchPosts searchPosts,
    required SearchPostsWithPageKey searchPostsWithPageKey,
  })  : _createPost = createPost,
        _createPostWithImage = createPostWithImage,
        _readPost = readPost,
        _readPosts = readPosts,
        _getPostsByUserId = getPostsByUserId,
        _updatePost = updatePost,
        _deletePost = deletePost,
        _searchPosts = searchPosts,
        _searchPostsWithPageKey = searchPostsWithPageKey,
        super(PostInitial());

  final CreatePost _createPost;
  final CreatePostWithImage _createPostWithImage;
  final ReadPost _readPost;
  final ReadPosts _readPosts;
  final GetPostsByUserId _getPostsByUserId;
  final UpdatePost _updatePost;
  final DeletePost _deletePost;
  final SearchPosts _searchPosts;
  final SearchPostsWithPageKey _searchPostsWithPageKey;

  Future<void> createPost(Post post) async {
    emit(PostLoading());
    final result = await _createPost(post);
    result.fold(
      (failure) => emit(PostError(failure.message)),
      (_) => emit(PostCreated()),
    );
  }

  Future<void> createPostWithImage({
    required Post post,
    required dynamic image,
  }) async {
    emit(PostLoading());
    final result = await _createPostWithImage(
      CreatePostWithImageParams(post: post, image: image),
    );
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

  Future<void> getPostsByUserId(String userId) async {
    emit(PostLoading());
    final result = await _getPostsByUserId(userId);

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
    List<String> tags = const [],
  }) async {
    // emit(PostLoading());
    final result = await _searchPostsWithPageKey(
      SearchPostsWithPageKeyParams(
        title: '',
        content: query,
        author: '',
        pageKey: pageKey,
        tags: tags,
      ),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(PostError(failure.message)),
      (searchResult) => emit(PostsSearchedWithPagekey(searchResult)),
    );
  }
}
