import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uniberry/core/enums/update_course_review_enum.dart';
import 'package:uniberry/core/errors/failures.dart';
import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/domain/repository/course_review_repository.dart';

class UpdateCourseReview
    implements UsecaseWithParams<void, UpdateCourseReviewParams> {
  final CourseReviewRepository repository;

  UpdateCourseReview(this.repository);

  @override
  ResultFuture<void> call(UpdateCourseReviewParams params) async {
    return await repository.updateCourseReview(
      reviewId: params.reviewId,
      action: params.action,
      reviewData: params.reviewData,
    );
  }
}

class UpdateCourseReviewParams extends Equatable {
  final String reviewId;
  final UpdateCourseReviewAction action;
  final dynamic reviewData;

  UpdateCourseReviewParams({
    required this.reviewId,
    required this.action,
    required this.reviewData,
  });

  @override
  List<Object?> get props => [reviewId, action, reviewData];
}
