import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry/src/forum/domain/repository/post_repository.dart';
import 'package:uniberry/src/forum/domain/usecases/search_posts.dart';

import 'repository.mock.dart';

void main() {
  late PostRepository repo;
  late SearchPosts usecase;

  setUp(() {
    repo = MockPostRepository();
    usecase = SearchPosts(repo);
  });

  const tPostIds = ['DaEBpyYgtZsiqXEJrB1m', 'HfriePN36BDqAFS6GbVw'];

  test('should call [PostRepository.searchPosts]', () async {
    // arrange
    when(
      () => repo.searchPosts(
        title: any(named: 'title'),
        content: any(named: 'content'),
        author: any(named: 'author'),
      ),
    ).thenAnswer((_) async => const Right(tPostIds));
    // act
    final result = await usecase(
      const SearchPostsParams(
        title: '_empty.title',
        content: '_empty.content',
        author: '_empty.author',
      ),
    );
    // assert
    expect(result, const Right<dynamic, List<String>>(tPostIds));
  });
}
