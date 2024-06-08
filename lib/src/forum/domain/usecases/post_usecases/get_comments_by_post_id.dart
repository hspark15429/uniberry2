import 'package:uniberry2/core/usecases/usecases.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/domain/entities/comment.dart';
import 'package:uniberry2/src/forum/domain/repository/comment_repository.dart';

class GetCommentsByPostId implements UsecaseWithParams<List<Comment>, String> {
  const GetCommentsByPostId(this._repo);

  final CommentRepository _repo;

  @override
  ResultFuture<List<Comment>> call(String postId) async {
    return _repo.getCommentsByPostId(postId);
  }
}
