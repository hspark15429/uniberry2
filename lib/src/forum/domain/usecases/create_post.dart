import 'package:uniberry2/core/usecases/usecases.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';
import 'package:uniberry2/src/forum/domain/repository/post_repository.dart';

class CreatePost implements UsecaseWithParams<void, Post> {
  const CreatePost(this._repo);

  final PostRepository _repo;

  @override
  ResultFuture<void> call(Post post) async {
    return _repo.createPost(post);
  }
}
