import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:uniberry2/core/enums/update_post_enum.dart';
import 'package:uniberry2/src/forum/data/models/post_model.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';
import 'package:uniberry2/src/forum/domain/usecases/create_post.dart';
import 'package:uniberry2/src/forum/domain/usecases/delete_post.dart';
import 'package:uniberry2/src/forum/domain/usecases/read_post.dart';
import 'package:uniberry2/src/forum/domain/usecases/update_post.dart';
import 'package:uniberry2/src/forum/presentation/cubit/post_cubit.dart';

class MockCreatePost extends Mock implements CreatePost {}

class MockReadPost extends Mock implements ReadPost {}

class MockUpdatePost extends Mock implements UpdatePost {}

class MockDeletePost extends Mock implements DeletePost {}

void main() {
  late CreatePost createPost;
  late ReadPost readPost;
  late UpdatePost updatePost;
  late DeletePost deletePost;
  late PostCubit cubit;

  final tPost = PostModel.empty();

  setUp(() {
    createPost = MockCreatePost();
    readPost = MockReadPost();
    updatePost = MockUpdatePost();
    deletePost = MockDeletePost();
    cubit = PostCubit(
      updatePost: updatePost,
      createPost: createPost,
      readPost: readPost,
      deletePost: deletePost,
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
      act: (cubit) => cubit.createPost(
        title: tPost.title,
        content: tPost.content,
        author: tPost.author,
        updatedAt: tPost.updatedAt,
        createdAt: tPost.createdAt,
      ),
      expect: () => [PostLoading(), PostCreated()],
      verify: (_) {
        verify(() => createPost(tPost.copyWith(postId: ''))).called(1);
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
}
