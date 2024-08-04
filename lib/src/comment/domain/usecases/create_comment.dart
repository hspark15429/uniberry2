import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/comment/domain/entities/comment.dart';
import 'package:uniberry/src/comment/domain/repository/comment_repository.dart';

class CreateComment implements UsecaseWithParams<void, Comment> {
  const CreateComment(this._repo);

  final CommentRepository _repo;

  @override
  ResultFuture<void> call(Comment comment) async {
    return _repo.createComment(comment);
  }
}
