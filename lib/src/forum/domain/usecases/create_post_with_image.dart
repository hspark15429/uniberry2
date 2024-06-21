import 'package:equatable/equatable.dart';
import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/domain/entities/post.dart';
import 'package:uniberry/src/forum/domain/repository/post_repository.dart';

class CreatePostWithImage
    implements UsecaseWithParams<void, CreatePostWithImageParams> {
  const CreatePostWithImage(this._repo);

  final PostRepository _repo;

  @override
  ResultFuture<void> call(CreatePostWithImageParams params) async {
    return _repo.createPostWithImage(post: params.post, image: params.image);
  }
}

class CreatePostWithImageParams extends Equatable {
  const CreatePostWithImageParams({
    required this.post,
    required this.image,
  });

  CreatePostWithImageParams.empty()
      : post = Post.empty(),
        image = '_empty.image';

  final Post post;
  final dynamic image;

  @override
  List<Object?> get props => [post, image];
}
