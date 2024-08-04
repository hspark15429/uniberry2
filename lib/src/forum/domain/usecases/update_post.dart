import 'package:equatable/equatable.dart';
import 'package:uniberry/core/enums/update_post_enum.dart';
import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/domain/repository/post_repository.dart';

class UpdatePost implements UsecaseWithParams<void, UpdatePostParams> {
  const UpdatePost(this._repo);

  final PostRepository _repo;

  @override
  ResultFuture<void> call(UpdatePostParams params) {
    return _repo.updatePost(
      postId: params.postId,
      action: params.action,
      postData: params.postData,
    );
  }
}

class UpdatePostParams extends Equatable {
  const UpdatePostParams({
    required this.postId,
    required this.action,
    required this.postData,
  });

  const UpdatePostParams.empty()
      : postId = '',
        action = UpdatePostAction.title,
        postData = '';

  final String postId;
  final UpdatePostAction action;
  final dynamic postData;

  @override
  List<Object?> get props => [action, postData];
}
