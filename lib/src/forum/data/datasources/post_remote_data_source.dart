import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/src/forum/data/models/post_model.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';

abstract class PostRemoteDataSource {
  const PostRemoteDataSource();
  Future<void> createPost(Post post);
  Future<void> deletePost(String postId);
  Future<PostModel> readPost(String postId);
  Future<List<String>> searchPosts({
    required String author,
    required String title,
    required String content,
  });
  Future<void> updatePost(PostModel post);
}

class PostRemoteDataSourceImplementation implements PostRemoteDataSource {
  PostRemoteDataSourceImplementation({
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
  })  : _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;

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
  Future<void> deletePost(String postId) {
    // TODO: implement deletePost
    throw UnimplementedError();
  }

  @override
  Future<PostModel> readPost(String postId) {
    // TODO: implement readPost
    throw UnimplementedError();
  }

  @override
  Future<List<String>> searchPosts(
      {required String author,
      required String title,
      required String content}) {
    // TODO: implement searchPosts
    throw UnimplementedError();
  }

  @override
  Future<void> updatePost(PostModel post) {
    // TODO: implement updatePost
    throw UnimplementedError();
  }
}
