import 'package:dartz/dartz.dart';
import 'package:uniberry2/core/enums/update_post_enum.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/core/errors/failures.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/data/datasources/post_remote_data_source.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';
import 'package:uniberry2/src/forum/domain/repository/post_repository.dart';

class PostRepositoryImplementation implements PostRepository {
  PostRepositoryImplementation(this._remoteDataSource);

  final PostRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> createPost(Post post) async {
    try {
      final result = await _remoteDataSource.createPost(post);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<Post> readPost(String postId) async {
    try {
      final result = await _remoteDataSource.readPost(postId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<Post>> readPosts(List<String> postIds) async {
    try {
      final result = await _remoteDataSource.readPosts(postIds);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> updatePost({
    required String postId,
    required UpdatePostAction action,
    required dynamic postData,
  }) async {
    try {
      final result = await _remoteDataSource.updatePost(
        postId: postId,
        action: action,
        postData: postData,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> deletePost(String postId) async {
    try {
      final result = await _remoteDataSource.deletePost(postId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<String>> searchPosts({
    required String author,
    required String title,
    required String content,
  }) async {
    try {
      final result = await _remoteDataSource.searchPosts(
        author: author,
        title: title,
        content: content,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<SearchPostsWithPageKeyResult> searchPostsWithPageKey({
    required String author,
    required String title,
    required String content,
    required int pageKey,
    List<String> tags = const [],
  }) async {
    try {
      final result = await _remoteDataSource.searchPostsWithPageKey(
        author: author,
        title: title,
        content: content,
        pageKey: pageKey,
        tags: tags,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
