import 'package:uniberry2/core/usecases/usecases.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';
import 'package:uniberry2/src/forum/domain/repository/post_repository.dart';

class ReadPost implements UsecaseWithParams<Post, String> {
  const ReadPost(this._repo);

  final PostRepository _repo;

  @override
  ResultFuture<Post> call(String id) async {
    return _repo.readPost(id);
  }
}
