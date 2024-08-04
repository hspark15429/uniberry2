part of 'course_review_cubit.dart';

sealed class CourseReviewState extends Equatable {
  const CourseReviewState();

  @override
  List<Object> get props => [];
}

final class CourseReviewInitial extends CourseReviewState {}

final class CourseReviewLoading extends CourseReviewState {}

final class CourseReviewCreated extends CourseReviewState {}

final class CourseReviewRead extends CourseReviewState {
  const CourseReviewRead(this.review);

  final CourseReview review;

  @override
  List<Object> get props => [review];
}

final class CourseReviewsRead extends CourseReviewState {
  const CourseReviewsRead(this.reviews);

  final List<CourseReview> reviews;

  @override
  List<Object> get props => [reviews];
}

final class CourseReviewUpdated extends CourseReviewState {}

final class CourseReviewDeleted extends CourseReviewState {}

final class CourseReviewsSearched extends CourseReviewState {
  const CourseReviewsSearched(this.reviewIds);

  final List<String> reviewIds;

  @override
  List<Object> get props => [reviewIds];
}

final class CourseReviewsSearchedWithPagekey extends CourseReviewState {
  const CourseReviewsSearchedWithPagekey(this.searchResult);

  final SearchCourseReviewsWithPageKeyResult searchResult;

  @override
  List<Object> get props => [searchResult];
}

final class CourseReviewError extends CourseReviewState {
  const CourseReviewError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
