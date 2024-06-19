import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:typesense/typesense.dart';
import 'package:uniberry/core/enums/update_post_enum.dart';
import 'package:uniberry/core/errors/exceptions.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/data/models/post_model.dart';
import 'package:uniberry/src/forum/domain/entities/post.dart';
import 'package:uniberry/src/forum/domain/repository/post_repository.dart';
import 'package:uniberry/src/forum/domain/usecases/search_posts.dart';

abstract class PostRemoteDataSource {
  const PostRemoteDataSource();
  Future<void> createPost(Post post);
  Future<PostModel> readPost(String postId);
  Future<List<PostModel>> readPosts(List<String> postIds);
  Future<List<PostModel>> getPostsByUserId(String userId);
  Future<void> updatePost({
    required String postId,
    required UpdatePostAction action,
    required dynamic postData,
  });
  Future<void> deletePost(String postId);

  Future<List<String>> searchPosts({
    required String author,
    required String title,
    required String content,
  });
  Future<SearchPostsWithPageKeyResult> searchPostsWithPageKey({
    required String author,
    required String title,
    required String content,
    required int pageKey,
    List<String> tags,
  });
}

class PostRemoteDataSourceImplementation implements PostRemoteDataSource {
  PostRemoteDataSourceImplementation({
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
    required Client typesenseClient,
  })  : _typesenseClient = typesenseClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;
  final Client _typesenseClient;

  @override
  Future<void> createPost(Post post) async {
    try {
      final docReference = await _cloudStoreClient.collection('posts').add(
            (post as PostModel).toMap(),
          );
      await _cloudStoreClient.collection('posts').doc(docReference.id).update(
        {'postId': docReference.id},
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint(s.toString());
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<PostModel> readPost(String postId) async {
    try {
      final post =
          await _cloudStoreClient.collection('posts').doc(postId).get();
      return PostModel.fromMap(post.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint(s.toString());
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<List<PostModel>> readPosts(List<String> postIds) async {
    try {
      // final post =
      //     await _cloudStoreClient.collection('posts').doc(postId).get();
      // return PostModel.fromMap(post.data()!);
      final posts = await Future.wait(
        postIds.map(
          (postId) async {
            final post =
                await _cloudStoreClient.collection('posts').doc(postId).get();
            return PostModel.fromMap(post.data()!);
          },
        ),
      );
      return posts;
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint(s.toString());
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> updatePost({
    required String postId,
    required UpdatePostAction action,
    required dynamic postData,
  }) {
    try {
      if (action == UpdatePostAction.title) {
        return _cloudStoreClient.collection('posts').doc(postId).update(
          {'title': postData},
        );
      } else if (action == UpdatePostAction.content) {
        return _cloudStoreClient.collection('posts').doc(postId).update(
          {'content': postData},
        );
      } else {
        throw const ServerException(
          message: 'error occurred',
          statusCode: 'unknown error',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint(s.toString());
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> deletePost(String postId) {
    try {
      return _cloudStoreClient.collection('posts').doc(postId).delete();
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint(s.toString());
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<List<String>> searchPosts({
    required String author,
    required String title,
    required String content,
  }) async {
    try {
      final searchParameters = {
        'q': content.isEmpty ? '*' : content,
        'include_fields': 'postId',
        'query_by': 'title,content,author',
        // 'per_page': '50',
      };

      if (content.isNotEmpty) {
        searchParameters['per_page'] = '10';
      }

      final results = await _typesenseClient
          .collection('posts')
          .documents
          .search(searchParameters);

      final postIds = (results['hits'] as List)
          .map((post) => (post as DataMap)['document']['postId'] as String)
          .toList();

      return postIds;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '50555');
    }
  }

  @override
  Future<SearchPostsWithPageKeyResult> searchPostsWithPageKey({
    required String author,
    required String title,
    required String content,
    required int pageKey,
    List<String> tags = const [],
  }) async {
    try {
      final searchParameters = {
        'q': content.isEmpty ? '*' : content,
        'query_by': 'title,content,author',
        'page': pageKey.toString(),
        'sort_by': 'createdAt:desc',
        // 'per_page': '50',
      };

      if (content.isNotEmpty) {
        searchParameters['per_page'] = '10';
      }
      if (tags.isNotEmpty && tags != null) {
        searchParameters['filter_by'] = 'tags:=$tags';
      }

      final response = await _typesenseClient
          .collection('posts')
          .documents
          .search(searchParameters);

      final posts = (response['hits'] as List)
          .map((post) =>
              PostModel.fromJson((post as DataMap)['document'] as DataMap))
          .toList();

      final nbPages = ((response['found'] as int) / 10).ceil();
      final isLastPage = response['page'] as int >= nbPages;
      final nextPageKey = isLastPage ? null : pageKey + 1;

      return SearchPostsWithPageKeyResult(
        posts: posts,
        pageKey: pageKey,
        nextPageKey: nextPageKey,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '50555');
    }
  }

  @override
  Future<List<PostModel>> getPostsByUserId(String userId) async {
    try {
      final posts = await _cloudStoreClient
          .collection('posts')
          .where('uid', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return posts.docs.map((post) => PostModel.fromMap(post.data())).toList();
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      // debugPrint(s.toString());
      debugPrint(e.toString());
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }
}
