import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/core/enums/update_post_enum.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/core/errors/failures.dart';
import 'package:uniberry2/src/forum/data/datasources/post_remote_data_source.dart';
import 'package:uniberry2/src/forum/data/models/post_model.dart';
import 'package:uniberry2/src/forum/data/repositories/post_repository_implementation.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

void main() {
  late PostRemoteDataSource remoteDataSource;
  late PostRepositoryImplementation repo;

  final tPost = PostModel.empty();

  setUp(() {
    remoteDataSource = MockPostRemoteDataSource();
    repo = PostRepositoryImplementation(remoteDataSource);
    registerFallbackValue(tPost);
    registerFallbackValue(UpdatePostAction.title);
  });

  group('createPost', () {
    test(
        'should call [remoteDataSource.createPost] '
        'and return success', () async {
      // arrange
      when(() => remoteDataSource.createPost(any()))
          .thenAnswer((_) async => Future.value());

      // act
      final result = await repo.createPost(tPost);

      // assert
      expect(result, const Right<dynamic, void>(null));

      verify(() => remoteDataSource.createPost(tPost)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should call [remoteDataSource.createPost] '
        'and return failure', () async {
      // arrange
      when(() => remoteDataSource.createPost(any())).thenThrow(
        const ServerException(
          message: 'some.message',
          statusCode: 'some.code',
        ),
      );

      // act
      final result = await repo.createPost(tPost);

      // assert
      expect(
        result,
        Left<Failure, dynamic>(
          ServerFailure(
            message: 'some.message',
            statusCode: 'some.code',
          ),
        ),
      );

      verify(() => remoteDataSource.createPost(tPost)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('readPost', () {
    test(
        'should call [remoteDataSource.readPost] '
        'and return success', () async {
      // arrange
      when(() => remoteDataSource.readPost(any()))
          .thenAnswer((_) async => tPost);

      // act
      final result = await repo.readPost('_empty.postId');

      // assert
      expect(result, Right<dynamic, Post>(tPost));

      verify(() => remoteDataSource.readPost('_empty.postId')).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should call [remoteDataSource.readPost] '
        'and return failure', () async {
      // arrange
      when(() => remoteDataSource.readPost(any())).thenThrow(
        const ServerException(
          message: 'some.message',
          statusCode: 'some.code',
        ),
      );

      // act
      final result = await repo.readPost('_empty.postId');

      // assert
      expect(
        result,
        Left<Failure, dynamic>(
          ServerFailure(
            message: 'some.message',
            statusCode: 'some.code',
          ),
        ),
      );

      verify(() => remoteDataSource.readPost('_empty.postId')).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('updatePost', () {
    test('should call [remoteDataSource.updatePost] and return success',
        () async {
      // arrange
      when(
        () => remoteDataSource.updatePost(
          postId: any(named: 'postId'),
          action: any(named: 'action'),
          postData: any<dynamic>(named: 'postData'),
        ),
      ).thenAnswer((_) async => Future.value());
      // act
      final result = await repo.updatePost(
        postId: '_empty.postId',
        action: UpdatePostAction.title,
        postData: 'new title',
      );

      // assert
      expect(result, const Right<dynamic, void>(null));
      verify(
        () => remoteDataSource.updatePost(
          postId: '_empty.postId',
          action: UpdatePostAction.title,
          postData: 'new title',
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('deletePost', () {
    test(
        'should call [remoteDataSource.deletePost] '
        'and return success', () async {
      // arrange
      when(() => remoteDataSource.deletePost(any()))
          .thenAnswer((_) async => Future.value());

      // act
      final result = await repo.deletePost('_empty.postId');

      // assert
      expect(result, const Right<dynamic, void>(null));

      verify(() => remoteDataSource.deletePost('_empty.postId')).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should call [remoteDataSource.deletePost] '
        'and return failure', () async {
      // arrange
      when(() => remoteDataSource.deletePost(any())).thenThrow(
        const ServerException(
          message: 'some.message',
          statusCode: 'some.code',
        ),
      );

      // act
      final result = await repo.deletePost('_empty.postId');

      // assert
      expect(
        result,
        Left<Failure, dynamic>(
          ServerFailure(
            message: 'some.message',
            statusCode: 'some.code',
          ),
        ),
      );

      verify(() => remoteDataSource.deletePost('_empty.postId')).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
