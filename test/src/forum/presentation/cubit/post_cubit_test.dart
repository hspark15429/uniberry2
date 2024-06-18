import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/core/enums/update_post_enum.dart';
import 'package:uniberry2/src/forum/data/models/post_model.dart';
import 'package:uniberry2/src/forum/domain/usecases/create_post.dart';
import 'package:uniberry2/src/forum/domain/usecases/create_post_with_image.dart';
import 'package:uniberry2/src/forum/domain/usecases/delete_post.dart';
import 'package:uniberry2/src/forum/domain/usecases/read_post.dart';
import 'package:uniberry2/src/forum/domain/usecases/read_posts.dart';
import 'package:uniberry2/src/forum/domain/usecases/search_posts.dart';
import 'package:uniberry2/src/forum/domain/usecases/search_posts_with_page_key.dart';
import 'package:uniberry2/src/forum/domain/usecases/update_post.dart';
import 'package:uniberry2/src/forum/presentation/cubit/post_cubit.dart';

class MockCreatePost extends Mock implements CreatePost {}

class MockCreatePostWithImage extends Mock implements CreatePostWithImage {}

class MockReadPost extends Mock implements ReadPost {}

class MockReadPosts extends Mock implements ReadPosts {}

class MockUpdatePost extends Mock implements UpdatePost {}

class MockDeletePost extends Mock implements DeletePost {}

class MockSearchPosts extends Mock implements SearchPosts {}

class MockSearchPostsWithPageKey extends Mock
    implements SearchPostsWithPageKey {}

void main() {
  late CreatePost createPost;
  late CreatePostWithImage createPostWithImage;
  late ReadPost readPost;
  late ReadPosts readPosts;
  late UpdatePost updatePost;
  late DeletePost deletePost;
  late SearchPosts searchPosts;
  late SearchPostsWithPageKey searchPostsWithPageKey;
  late PostCubit cubit;

  final tPost = PostModel.empty();

  setUp(() {
    createPost = MockCreatePost();
    createPostWithImage = MockCreatePostWithImage();
    readPost = MockReadPost();
    readPosts = MockReadPosts();
    updatePost = MockUpdatePost();
    deletePost = MockDeletePost();
    searchPosts = MockSearchPosts();
    searchPostsWithPageKey = MockSearchPostsWithPageKey();
    cubit = PostCubit(
      updatePost: updatePost,
      createPost: createPost,
      createPostWithImage: createPostWithImage,
      readPost: readPost,
      readPosts: readPosts,
      deletePost: deletePost,
      searchPosts: searchPosts,
      searchPostsWithPageKey: searchPostsWithPageKey,
    );
    registerFallbackValue(PostModel.empty());
    registerFallbackValue(const UpdatePostParams.empty());
  });

  test('check initial state', () {
    expect(cubit.state, PostInitial());
  });

  tearDown(() {
    cubit.close();
  });

  group('createPost', () {
    blocTest<PostCubit, PostState>(
      'emits [PostLoading, PostCreated] when successful',
      build: () {
        when(() => createPost.call(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.createPost(tPost),
      expect: () => [PostLoading(), PostCreated()],
      verify: (_) {
        verify(() => createPost(tPost.copyWith(postId: '_empty.postId')))
            .called(1);
        verifyNoMoreInteractions(createPost);
      },
    );
  });
  group('readPost', () {
    blocTest<PostCubit, PostState>(
      'emits [PostLoading, PostRead] when successful',
      build: () {
        when(() => readPost.call(any())).thenAnswer((_) async => Right(tPost));
        return cubit;
      },
      act: (cubit) => cubit.readPost('postId'),
      expect: () => [PostLoading(), PostRead(tPost)],
      verify: (_) {
        verify(() => readPost('postId')).called(1);
        verifyNoMoreInteractions(readPost);
      },
    );
  });

  group('updatePost', () {
    blocTest<PostCubit, PostState>(
      'emits [PostLoading, PostUpdated] when successful',
      build: () {
        when(() => updatePost.call(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.updatePost(
        postId: 'postId',
        action: UpdatePostAction.title,
        postData: 'new title',
      ),
      expect: () => [PostLoading(), PostUpdated()],
      verify: (_) {
        verify(
          () => updatePost(
            const UpdatePostParams(
              postId: 'postId',
              action: UpdatePostAction.title,
              postData: 'new title',
            ),
          ),
        ).called(1);
        verifyNoMoreInteractions(createPost);
      },
    );
  });

  group('deletePost', () {
    blocTest<PostCubit, PostState>(
      'emits [PostLoading, PostDeleted] when successful',
      build: () {
        when(() => deletePost.call(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.deletePost(tPost.postId),
      expect: () => [PostLoading(), PostDeleted()],
      verify: (_) {
        verify(() => deletePost(tPost.postId)).called(1);
        verifyNoMoreInteractions(deletePost);
      },
    );
  });

  group('searchPosts', () {
    blocTest<PostCubit, PostState>(
      'emits [PostLoading, PostsSearched] when successful',
      build: () {
        registerFallbackValue(const SearchPostsParams.empty());
        when(() => searchPosts.call(any()))
            .thenAnswer((_) async => const Right(['postId']));
        return cubit;
      },
      act: (cubit) => cubit.searchPosts(tPost.title),
      expect: () => [
        PostLoading(),
        const PostsSearched(['postId']),
      ],
      verify: (_) {
        verify(
          () => searchPosts(
            SearchPostsParams(
              title: '',
              content: tPost.title,
              author: '',
            ),
          ),
        ).called(1);
        verifyNoMoreInteractions(searchPosts);
      },
    );
  });
}
