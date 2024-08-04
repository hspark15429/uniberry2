import 'package:dartz/dartz.dart';
import 'package:uniberry/core/errors/failures.dart';
import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/domain/entities/course_review.dart';
import 'package:uniberry/src/forum/domain/repository/course_review_repository.dart';

class CreateCourseReview implements UsecaseWithParams<void, CourseReview> {
  final CourseReviewRepository repository;

  CreateCourseReview(this.repository);

  @override
  ResultFuture<void> call(CourseReview review) async {
    return await repository.createCourseReview(review);
  }
}
