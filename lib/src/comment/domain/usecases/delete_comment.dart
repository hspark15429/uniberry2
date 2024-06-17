import 'package:uniberry2/core/usecases/usecases.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/comment/domain/repository/comment_repository.dart';

class DeleteComment implements UsecaseWithParams<void, String> {
  DeleteComment(this._repo);

  final CommentRepository _repo;

  @override
  ResultFuture<void> call(String commentId) async {
    return _repo.deleteComment(commentId);
  }
}
