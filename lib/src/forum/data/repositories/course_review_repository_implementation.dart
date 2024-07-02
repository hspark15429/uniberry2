import 'package:dartz/dartz.dart';
import 'package:uniberry/core/enums/update_course_review_enum.dart';
import 'package:uniberry/core/errors/exceptions.dart';
import 'package:uniberry/core/errors/failures.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/data/datasources/course_review_remote_data_source.dart';
import 'package:uniberry/src/forum/domain/entities/course_review.dart';
import 'package:uniberry/src/forum/domain/repository/course_review_repository.dart';
import 'package:uniberry/src/forum/domain/usecases/course_review/search_course_review_with_page_key.dart';

class CourseReviewRepositoryImplementation implements CourseReviewRepository {
  CourseReviewRepositoryImplementation(this._remoteDataSource);

  final CourseReviewRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> createCourseReview(CourseReview review) async {
    try {
      await _remoteDataSource.createCourseReview(review);
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> createCourseReviewWithImage({
    required CourseReview review,
    required dynamic image,
  }) async {
    try {
      await _remoteDataSource.createCourseReviewWithImage(
        review: review,
        image: image,
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<CourseReview> readCourseReview(String reviewId) async {
    try {
      final result = await _remoteDataSource.readCourseReview(reviewId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<CourseReview>> readCourseReviews(
      List<String> reviewIds) async {
    try {
      final result = await _remoteDataSource.readCourseReviews(reviewIds);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<CourseReview>> getCourseReviewsByUserId(
      String userId) async {
    try {
      final result = await _remoteDataSource.getCourseReviewsByUserId(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> updateCourseReview({
    required String reviewId,
    required UpdateCourseReviewAction action,
    required dynamic reviewData,
  }) async {
    try {
      await _remoteDataSource.updateCourseReview(
        reviewId: reviewId,
        action: action,
        reviewData: reviewData,
      );
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> deleteCourseReview(String reviewId) async {
    try {
      await _remoteDataSource.deleteCourseReview(reviewId);
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<String>> searchCourseReviews({
    required String author,
    required String courseName,
    required String comments,
    required String title,
  }) async {
    try {
      final result = await _remoteDataSource.searchCourseReviews(
        author: author,
        courseName: courseName,
        comments: comments,
        title: title,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, SearchCourseReviewsWithPageKeyResult>>
      searchCourseReviewsWithPageKey({
    required String author,
    required String courseName,
    required String comments,
    required int pageKey,
    List<String> tags = const [],
  }) async {
    try {
      final result = await _remoteDataSource.searchCourseReviewsWithPageKey(
        author: author,
        courseName: courseName,
        comments: comments,
        pageKey: pageKey,
        tags: tags,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
