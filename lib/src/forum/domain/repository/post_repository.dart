import 'package:equatable/equatable.dart';
import 'package:uniberry2/core/enums/update_post_enum.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';

abstract class PostRepository {
  const PostRepository();

  ResultFuture<void> createPost(Post post);
  ResultFuture<void> createPostWithImage({
    required Post post,
    required dynamic image,
  });
  ResultFuture<Post> readPost(String postId);
  ResultFuture<List<Post>> readPosts(List<String> postIds);
  ResultFuture<List<Post>> getPostsByUserId(String userId);
  ResultFuture<void> updatePost({
    required String postId,
    required UpdatePostAction action,
    required dynamic postData,
  });
  ResultFuture<void> deletePost(String postId);

  // search post from server by keyword. Returns doc id's
  ResultFuture<List<String>> searchPosts({
    required String author,
    required String title,
    required String content,
  });

  ResultFuture<SearchPostsWithPageKeyResult> searchPostsWithPageKey({
    required String author,
    required String title,
    required String content,
    required int pageKey,
    List<String> tags,
  });
}

class SearchPostsWithPageKeyResult extends Equatable {
  const SearchPostsWithPageKeyResult({
    required this.posts,
    required this.pageKey,
    this.nextPageKey,
  });
  final List<Post> posts;
  final int pageKey;
  final int? nextPageKey;

  @override
  List<Object?> get props => [posts, pageKey, nextPageKey];
}
