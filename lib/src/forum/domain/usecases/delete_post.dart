import 'package:uniberry2/core/usecases/usecases.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/domain/repository/post_repository.dart';

class DeletePost implements UsecaseWithParams<void, String> {
  DeletePost(this._repo);

  final PostRepository _repo;

  @override
  ResultFuture<void> call(String postId) async {
    return _repo.deletePost(postId);
  }
}
