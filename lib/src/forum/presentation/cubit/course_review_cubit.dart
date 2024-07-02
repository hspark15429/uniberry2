import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniberry/core/enums/update_course_review_enum.dart';
import 'package:uniberry/src/forum/domain/entities/course_review.dart';
import 'package:uniberry/src/forum/domain/usecases/course_review/create_course_review.dart';
import 'package:uniberry/src/forum/domain/usecases/course_review/delete_course_review.dart';
import 'package:uniberry/src/forum/domain/usecases/course_review/get_course_reviews_by_user_id.dart';
import 'package:uniberry/src/forum/domain/usecases/course_review/read_course_review.dart';
import 'package:uniberry/src/forum/domain/usecases/course_review/read_couse_reviews.dart';

import 'package:uniberry/src/forum/domain/usecases/course_review/search_course_review.dart';
import 'package:uniberry/src/forum/domain/usecases/course_review/search_course_review_with_page_key.dart';
import 'package:uniberry/src/forum/domain/usecases/course_review/update_course_review.dart';

part 'course_review_state.dart';

class CourseReviewCubit extends Cubit<CourseReviewState> {
  CourseReviewCubit({
    required CreateCourseReview createCourseReview,
    required ReadCourseReview readCourseReview,
    required ReadCourseReviews readCourseReviews,
    required GetCourseReviewsByUserId getCourseReviewsByUserId,
    required UpdateCourseReview updateCourseReview,
    required DeleteCourseReview deleteCourseReview,
    required SearchCourseReviews searchCourseReviews,
    required SearchCourseReviewsWithPageKey searchCourseReviewsWithPageKey,
  })  : _createCourseReview = createCourseReview,
        _readCourseReview = readCourseReview,
        _readCourseReviews = readCourseReviews,
        _getCourseReviewsByUserId = getCourseReviewsByUserId,
        _updateCourseReview = updateCourseReview,
        _deleteCourseReview = deleteCourseReview,
        _searchCourseReviews = searchCourseReviews,
        _searchCourseReviewsWithPageKey = searchCourseReviewsWithPageKey,
        super(CourseReviewInitial());

  final CreateCourseReview _createCourseReview;
  final ReadCourseReview _readCourseReview;
  final ReadCourseReviews _readCourseReviews;
  final GetCourseReviewsByUserId _getCourseReviewsByUserId;
  final UpdateCourseReview _updateCourseReview;
  final DeleteCourseReview _deleteCourseReview;
  final SearchCourseReviews _searchCourseReviews;
  final SearchCourseReviewsWithPageKey _searchCourseReviewsWithPageKey;

  Future<void> createCourseReview(CourseReview courseReview) async {
    emit(CourseReviewLoading());
    final result = await _createCourseReview(courseReview);
    result.fold(
      (failure) => emit(CourseReviewError(failure.message)),
      (_) => emit(CourseReviewCreated()),
    );
  }

  Future<void> readCourseReview(String reviewId) async {
    emit(CourseReviewLoading());
    final result = await _readCourseReview(reviewId);
    result.fold(
      (failure) => emit(CourseReviewError(failure.message)),
      (review) => emit(CourseReviewRead(review)),
    );
  }

  Future<void> readCourseReviews(List<String> reviewIds) async {
    emit(CourseReviewLoading());
    final result = await _readCourseReviews(reviewIds);
    result.fold(
      (failure) => emit(CourseReviewError(failure.message)),
      (reviews) => emit(CourseReviewsRead(reviews)),
    );
  }

  Future<void> getCourseReviewsByUserId(String userId) async {
    emit(CourseReviewLoading());
    final result = await _getCourseReviewsByUserId(userId);
    result.fold(
      (failure) => emit(CourseReviewError(failure.message)),
      (reviews) => emit(CourseReviewsRead(reviews)),
    );
  }

  Future<void> updateCourseReview({
    required String reviewId,
    required UpdateCourseReviewAction action,
    required dynamic reviewData,
  }) async {
    emit(CourseReviewLoading());
    final result = await _updateCourseReview(
      UpdateCourseReviewParams(
        reviewId: reviewId,
        action: action,
        reviewData: reviewData,
      ),
    );
    result.fold(
      (failure) => emit(CourseReviewError(failure.message)),
      (_) => emit(CourseReviewUpdated()),
    );
  }

  Future<void> deleteCourseReview(String reviewId) async {
    emit(CourseReviewLoading());
    final result = await _deleteCourseReview(reviewId);
    result.fold(
      (failure) => emit(CourseReviewError(failure.message)),
      (_) => emit(CourseReviewDeleted()),
    );
  }

  Future<void> searchCourseReviews(String query) async {
    emit(CourseReviewLoading());
    final result = await _searchCourseReviews(
      SearchCourseReviewsParams(
        courseName: query,
        comments: '',
        author: '',
        title: '',
        content: '',
      ),
    );
    result.fold(
      (failure) => emit(CourseReviewError(failure.message)),
      (reviewIds) => emit(CourseReviewsSearched(reviewIds)),
    );
  }

  Future<void> searchCourseReviewsWithPageKey({
    required String query,
    required int pageKey,
    List<String> tags = const [],
  }) async {
    final result = await _searchCourseReviewsWithPageKey(
      SearchCourseReviewsWithPageKeyParams(
        courseName: query,
        content: '',
        author: '',
        pageKey: pageKey,
        tags: tags,
      ),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(CourseReviewError(failure.message)),
      (searchResult) => emit(CourseReviewsSearchedWithPagekey(searchResult)),
    );
  }
}
