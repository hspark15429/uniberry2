import 'package:uniberry2/core/usecases/usecases.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/comment/domain/entities/comment.dart';

import 'package:uniberry2/src/comment/domain/repository/comment_repository.dart';

class GetCommentsByUserId implements UsecaseWithParams<List<Comment>, String> {
  const GetCommentsByUserId(this._repo);

  final CommentRepository _repo;

  @override
  ResultFuture<List<Comment>> call(String userId) async {
    return _repo.getCommentsByPostId(userId);
  }
}
