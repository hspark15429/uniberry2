import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uniberry/core/enums/update_comment_enum.dart';
import 'package:uniberry/core/errors/exceptions.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/comment/data/models/comment_model.dart';
import 'package:uniberry/src/comment/domain/entities/comment.dart';

abstract class CommentRemoteDataSource {
  const CommentRemoteDataSource();
  Future<void> createComment(Comment comment);
  Future<List<Comment>> getCommentsByPostId(String postId);
  Future<List<Comment>> getCommentsByUserId(String userId);
  Future<List<Comment>> getCommentsByParentCommentId(String parentCommentId);
  Future<void> updateComment({
    required String commentId,
    required UpdateCommentAction action,
    required dynamic commentData,
  });
  Future<void> deleteComment(String commentId);
}

class CommentRemoteDataSourceImplementation implements CommentRemoteDataSource {
  const CommentRemoteDataSourceImplementation({
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
  })  : _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;

  @override
  Future<void> createComment(Comment comment) async {
    try {
      final docReference = await _cloudStoreClient.collection('comments').add(
            (comment as CommentModel).toMap(),
          );
      await _cloudStoreClient
          .collection('comments')
          .doc(docReference.id)
          .update(
        {'commentId': docReference.id},
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
  Future<void> deleteComment(String commentId) async {
    try {
      return _cloudStoreClient.collection('comments').doc(commentId).delete();
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint(e.toString());
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<List<Comment>> getCommentsByPostId(String postId) async {
    try {
      final comments = await _cloudStoreClient
          .collection('comments')
          .where('postId', isEqualTo: postId)
          .where('parentCommentId', isNull: true)
          .orderBy('createdAt', descending: true)
          .get();
      return comments.docs
          .map((comment) => CommentModel.fromMap(comment.data()))
          .toList();
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

  @override
  Future<List<Comment>> getCommentsByUserId(String userId) async {
    try {
      final comments = await _cloudStoreClient
          .collection('comments')
          .where('uid', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return comments.docs
          .map((comment) => CommentModel.fromMap(comment.data()))
          .toList();
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

  @override
  Future<List<Comment>> getCommentsByParentCommentId(
    String parentCommentId,
  ) async {
    try {
      final comments = await _cloudStoreClient
          .collection('comments')
          .where('parentCommentId', isEqualTo: parentCommentId)
          .orderBy('createdAt', descending: true)
          .get();
      return comments.docs
          .map((comment) => CommentModel.fromMap(comment.data()))
          .toList();
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

  @override
  Future<void> updateComment(
      {required String commentId,
      required UpdateCommentAction action,
      required dynamic commentData}) async {
    try {
      if (action == UpdateCommentAction.content) {
        return _cloudStoreClient.collection('comments').doc(commentId).update(
          {'content': commentData},
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
}
