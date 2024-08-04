import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/comment/domain/entities/comment.dart';

import 'package:uniberry/src/comment/domain/repository/comment_repository.dart';

class GetCommentsByPostId implements UsecaseWithParams<List<Comment>, String> {
  const GetCommentsByPostId(this._repo);

  final CommentRepository _repo;

  @override
  ResultFuture<List<Comment>> call(String postId) async {
    return _repo.getCommentsByPostId(postId);
  }
}
