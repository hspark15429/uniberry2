import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/core/errors/failures.dart';
import 'package:uniberry2/src/forum/data/datasources/post_remote_data_source.dart';
import 'package:uniberry2/src/forum/data/repositories/post_repository_implementation.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

void main() {
  late PostRemoteDataSource remoteDataSource;
  late PostRepositoryImplementation repo;

  const tPost = Post.empty();

  setUp(() {
    remoteDataSource = MockPostRemoteDataSource();
    repo = PostRepositoryImplementation(remoteDataSource);
    registerFallbackValue(tPost);
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
}
