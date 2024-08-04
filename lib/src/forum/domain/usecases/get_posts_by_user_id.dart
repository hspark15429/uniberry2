import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/domain/entities/post.dart';
import 'package:uniberry/src/forum/domain/repository/post_repository.dart';

class GetPostsByUserId implements UsecaseWithParams<List<Post>, String> {
  const GetPostsByUserId(this._repo);

  final PostRepository _repo;

  @override
  ResultFuture<List<Post>> call(String userId) async {
    return _repo.getPostsByUserId(userId);
  }
}
