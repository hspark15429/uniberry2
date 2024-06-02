import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';

abstract class PostRepository {
  const PostRepository();

  ResultFuture<void> createPost(Post post);
  ResultFuture<Post> readPost(String postId);
  ResultFuture<void> updatePost(Post post);
  ResultFuture<void> deletePost(String postId);

  // search post from server by keyword. Returns doc id's
  ResultFuture<List<String>> searchPosts({
    required String author,
    required String title,
    required String content,
  });
}