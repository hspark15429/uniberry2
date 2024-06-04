import 'dart:async';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uniberry2/core/enums/update_post_enum.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/src/forum/data/models/post_model.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';

abstract class PostRemoteDataSource {
  const PostRemoteDataSource();
  Future<void> createPost(Post post);
  Future<PostModel> readPost(String postId);
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
}

class PostRemoteDataSourceImplementation implements PostRemoteDataSource {
  PostRemoteDataSourceImplementation({
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
    required HitsSearcher postsSearcher,
  })  : _postsSearcher = postsSearcher,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;
  final HitsSearcher _postsSearcher;

  final StreamController<HitsPage> _searchResultsController =
      StreamController<HitsPage>();
  Stream<HitsPage> get searchResultsStream => _searchResultsController.stream;

  Stream<HitsPage> get _searchPage =>
      _postsSearcher.responses.map(HitsPage.fromResponse);

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
      _postsSearcher.query(content);
      final results = await _searchPage.first;
      final postIds = results.items.map((post) => post.postId).toList();
      _postsSearcher.rerun();

      return postIds;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}

class HitsPage {
  const HitsPage(this.items, this.pageKey, this.nextPageKey);

  factory HitsPage.fromResponse(SearchResponse response) {
    final items = response.hits.map(PostModel.fromJson).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsPage(items, response.page, nextPageKey);
  }

  final List<PostModel> items;
  final int pageKey;
  final int? nextPageKey;
}
