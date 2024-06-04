import 'package:equatable/equatable.dart';
import 'package:uniberry2/core/usecases/usecases.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/domain/repository/post_repository.dart';

class SearchPosts
    implements UsecaseWithParams<List<String>, SearchPostsParams> {
  const SearchPosts(this._repo);

  final PostRepository _repo;

  @override
  ResultFuture<List<String>> call(SearchPostsParams params) async {
    final result = await _repo.searchPosts(
      author: params.author,
      title: params.title,
      content: params.content,
    );
    return result;
  }
}

class SearchPostsParams extends Equatable {
  const SearchPostsParams({
    required this.title,
    required this.content,
    required this.author,
  });

  const SearchPostsParams.empty()
      : title = '',
        content = '',
        author = '';

  final String title;
  final String content;
  final String author;

  @override
  List<Object?> get props => [title, content, author];
}
