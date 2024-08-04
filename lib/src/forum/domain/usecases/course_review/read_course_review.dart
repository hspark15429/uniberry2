import 'package:dartz/dartz.dart';
import 'package:uniberry/core/errors/failures.dart';
import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/domain/entities/course_review.dart';
import 'package:uniberry/src/forum/domain/repository/course_review_repository.dart';

class ReadCourseReview implements UsecaseWithParams<CourseReview, String> {
  final CourseReviewRepository repository;

  ReadCourseReview(this.repository);

  @override
  ResultFuture<CourseReview> call(String reviewId) async {
    return await repository.readCourseReview(reviewId);
  }
}
