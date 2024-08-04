import 'package:dartz/dartz.dart';
import 'package:uniberry/core/enums/update_course_review_enum.dart';
import 'package:uniberry/core/errors/failures.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/domain/entities/course_review.dart';
import 'package:uniberry/src/forum/domain/usecases/course_review/search_course_review_with_page_key.dart';

abstract class CourseReviewRepository {
  ResultFuture<void> createCourseReview(CourseReview review);
  ResultFuture<void> createCourseReviewWithImage({
    required CourseReview review,
    required dynamic image,
  });
  ResultFuture<CourseReview> readCourseReview(String reviewId);
  ResultFuture<List<CourseReview>> readCourseReviews(List<String> reviewIds);
  ResultFuture<List<CourseReview>> getCourseReviewsAll();
  ResultFuture<List<CourseReview>> getCourseReviewsByUserId(String userId);
  ResultFuture<void> updateCourseReview({
    required String reviewId,
    required UpdateCourseReviewAction action,
    required dynamic reviewData,
  });
  ResultFuture<void> deleteCourseReview(String reviewId);
  ResultFuture<List<String>> searchCourseReviews({
    required String author,
    required String courseName,
    required String comments,
    required String title,
  });
  Future<Either<Failure, SearchCourseReviewsWithPageKeyResult>>
      searchCourseReviewsWithPageKey({
    required String author,
    required String courseName,
    required String comments,
    required int pageKey,
    List<String> tags = const [],
  });
}
