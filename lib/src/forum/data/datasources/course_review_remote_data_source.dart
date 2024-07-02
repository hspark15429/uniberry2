import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:typesense/typesense.dart';
import 'package:uniberry/core/enums/update_course_review_enum.dart';
import 'package:uniberry/core/errors/exceptions.dart';
import 'package:uniberry/core/utils/core_utils.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/data/models/course_review_model.dart';
import 'package:uniberry/src/forum/domain/entities/course_review.dart';
import 'package:uniberry/src/forum/domain/repository/course_review_repository.dart';
import 'package:uniberry/src/forum/domain/usecases/course_review/search_course_review_with_page_key.dart';

abstract class CourseReviewRemoteDataSource {
  const CourseReviewRemoteDataSource();
  Future<void> createCourseReview(CourseReview review);
  Future<void> createCourseReviewWithImage({
    required CourseReview review,
    required dynamic image,
  });
  Future<CourseReviewModel> readCourseReview(String reviewId);
  Future<List<CourseReviewModel>> readCourseReviews(List<String> reviewIds);
  Future<List<CourseReviewModel>> getCourseReviewsByUserId(String userId);
  Future<void> updateCourseReview({
    required String reviewId,
    required UpdateCourseReviewAction action,
    required dynamic reviewData,
  });
  Future<void> deleteCourseReview(String reviewId);

  Future<List<String>> searchCourseReviews({
    required String author,
    required String courseName,
    required String comments,
    required String title,
  });
  Future<SearchCourseReviewsWithPageKeyResult> searchCourseReviewsWithPageKey({
    required String author,
    required String courseName,
    required String comments,
    required int pageKey,
    List<String> tags,
  });
}

class CourseReviewRemoteDataSourceImplementation
    implements CourseReviewRemoteDataSource {
  CourseReviewRemoteDataSourceImplementation({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
    required Client typesenseClient,
  })  : _authClient = authClient,
        _typesenseClient = typesenseClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;
  final Client _typesenseClient;

  @override
  Future<void> createCourseReview(CourseReview review) async {
    try {
      final docReference =
          await _cloudStoreClient.collection('course_reviews').add(
                (review as CourseReviewModel).toMap(),
              );
      await _cloudStoreClient
          .collection('course_reviews')
          .doc(docReference.id)
          .update(
        {'reviewId': docReference.id},
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
  Future<void> createCourseReviewWithImage({
    required CourseReview review,
    required dynamic image,
  }) async {
    try {
      if (image is File) {
        final compressedImage = await CoreUtils.compressFile(image);

        final docReference =
            await _cloudStoreClient.collection('course_reviews').add(
                  (review as CourseReviewModel).toMap(),
                );
        await _cloudStoreClient
            .collection('course_reviews')
            .doc(docReference.id)
            .update(
          {'reviewId': docReference.id},
        );
        final ref = _dbClient.ref().child(
            'course_reviews/images/user_uploaded/${_authClient.currentUser?.uid}/${docReference.id}');
        await ref.putFile(compressedImage);
        final url = await ref.getDownloadURL();
        await _cloudStoreClient
            .collection('course_reviews')
            .doc(docReference.id)
            .update(
          {'comments': url},
        );
      } else if (image is String) {
        final docReference =
            await _cloudStoreClient.collection('course_reviews').add(
                  (review as CourseReviewModel).toMap(),
                );
        await _cloudStoreClient
            .collection('course_reviews')
            .doc(docReference.id)
            .update(
          {'reviewId': docReference.id},
        );
      } else {
        throw const ServerException(
          message: 'image is not a file or a string',
          statusCode: 'wrong type',
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
  Future<CourseReviewModel> readCourseReview(String reviewId) async {
    try {
      final review = await _cloudStoreClient
          .collection('course_reviews')
          .doc(reviewId)
          .get();
      return CourseReviewModel.fromMap(review.data()!);
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
  Future<List<CourseReviewModel>> readCourseReviews(
      List<String> reviewIds) async {
    try {
      final reviews = await Future.wait(
        reviewIds.map(
          (reviewId) async {
            final review = await _cloudStoreClient
                .collection('course_reviews')
                .doc(reviewId)
                .get();
            return CourseReviewModel.fromMap(review.data()!);
          },
        ),
      );
      return reviews;
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
  Future<void> updateCourseReview({
    required String reviewId,
    required UpdateCourseReviewAction action,
    required dynamic reviewData,
  }) {
    try {
      if (action == UpdateCourseReviewAction.title) {
        return _cloudStoreClient
            .collection('course_reviews')
            .doc(reviewId)
            .update(
          {'title': reviewData},
        );
      } else if (action == UpdateCourseReviewAction.content) {
        return _cloudStoreClient
            .collection('course_reviews')
            .doc(reviewId)
            .update(
          {'content': reviewData},
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
  Future<void> deleteCourseReview(String reviewId) {
    try {
      return _cloudStoreClient
          .collection('course_reviews')
          .doc(reviewId)
          .delete();
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
  Future<List<String>> searchCourseReviews({
    required String author,
    required String courseName,
    required String comments,
    required String title,
  }) async {
    try {
      final searchParameters = {
        'q': comments.isEmpty ? '*' : comments,
        'include_fields': 'reviewId',
        'query_by': 'courseName,comments,author,title',
      };

      if (comments.isNotEmpty) {
        searchParameters['per_page'] = '10';
      }

      final results = await _typesenseClient
          .collection('course_reviews')
          .documents
          .search(searchParameters);

      final reviewIds = (results['hits'] as List)
          .map(
              (review) => (review as DataMap)['document']['reviewId'] as String)
          .toList();

      return reviewIds;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '50555');
    }
  }

  @override
  Future<SearchCourseReviewsWithPageKeyResult> searchCourseReviewsWithPageKey({
    required String author,
    required String courseName,
    required String comments,
    required int pageKey,
    List<String> tags = const [],
  }) async {
    try {
      final searchParameters = {
        'q': comments.isEmpty ? '*' : comments,
        'query_by': 'courseName,comments,author',
        'page': pageKey.toString(),
        'sort_by': 'createdAt:desc',
      };

      if (comments.isNotEmpty) {
        searchParameters['per_page'] = '10';
      }
      if (tags.isNotEmpty) {
        searchParameters['filter_by'] = 'tags:=$tags';
      }

      final response = await _typesenseClient
          .collection('course_reviews')
          .documents
          .search(searchParameters);

      final reviews = (response['hits'] as List)
          .map((review) => CourseReviewModel.fromJson(
              (review as DataMap)['document'] as DataMap))
          .toList();

      final nbPages = ((response['found'] as int) / 10).ceil();
      final isLastPage = response['page'] as int >= nbPages;
      final nextPageKey = isLastPage ? null : pageKey + 1;

      return SearchCourseReviewsWithPageKeyResult(
        reviews: reviews,
        pageKey: pageKey,
        nextPageKey: nextPageKey,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '50555');
    }
  }

  @override
  Future<List<CourseReviewModel>> getCourseReviewsByUserId(
      String userId) async {
    try {
      final reviews = await _cloudStoreClient
          .collection('course_reviews')
          .where('uid', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return reviews.docs
          .map((review) => CourseReviewModel.fromMap(review.data()))
          .toList();
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
}
