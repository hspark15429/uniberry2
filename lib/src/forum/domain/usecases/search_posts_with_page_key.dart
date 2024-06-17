import 'package:equatable/equatable.dart';
import 'package:uniberry2/core/usecases/usecases.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/domain/repository/post_repository.dart';

class SearchPostsWithPageKey
    implements
        UsecaseWithParams<SearchPostsWithPageKeyResult,
            SearchPostsWithPageKeyParams> {
  const SearchPostsWithPageKey(this._repo);

  final PostRepository _repo;

  @override
  ResultFuture<SearchPostsWithPageKeyResult> call(
    SearchPostsWithPageKeyParams params,
  ) async {
    final result = await _repo.searchPostsWithPageKey(
      author: params.author,
      title: params.title,
      content: params.content,
      pageKey: params.pageKey,
      tags: params.tags,
    );
    return result;
  }
}

class SearchPostsWithPageKeyParams extends Equatable {
  const SearchPostsWithPageKeyParams({
    required this.author,
    required this.title,
    required this.content,
    required this.pageKey,
    this.tags = const [],
  });

  const SearchPostsWithPageKeyParams.empty()
      : author = '',
        title = '',
        content = '',
        pageKey = 0,
        tags = const [];

  final String author;
  final String title;
  final String content;
  final int pageKey;
  final List<String> tags;

  @override
  List<Object?> get props => [author, title, content, pageKey, tags];
}
