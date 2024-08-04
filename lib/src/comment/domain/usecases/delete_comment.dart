import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/comment/domain/repository/comment_repository.dart';

class DeleteComment implements UsecaseWithParams<void, String> {
  DeleteComment(this._repo);

  final CommentRepository _repo;

  @override
  ResultFuture<void> call(String commentId) async {
    return _repo.deleteComment(commentId);
  }
}
