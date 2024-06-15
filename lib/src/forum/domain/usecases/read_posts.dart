import 'package:uniberry2/core/usecases/usecases.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';
import 'package:uniberry2/src/forum/domain/repository/post_repository.dart';

class ReadPosts implements UsecaseWithParams<List<Post>, List<String>> {
  const ReadPosts(this._repo);

  final PostRepository _repo;

  @override
  ResultFuture<List<Post>> call(List<String> ids) async {
    return _repo.readPosts(ids);
  }
}
