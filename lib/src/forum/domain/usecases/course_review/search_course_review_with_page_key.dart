import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uniberry/core/errors/failures.dart';
import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/domain/entities/course_review.dart';
import 'package:uniberry/src/forum/domain/repository/course_review_repository.dart';

class SearchCourseReviewsWithPageKey
    implements
        UsecaseWithParams<SearchCourseReviewsWithPageKeyResult,
            SearchCourseReviewsWithPageKeyParams> {
  const SearchCourseReviewsWithPageKey(this._repo);

  final CourseReviewRepository _repo;

  @override
  ResultFuture<SearchCourseReviewsWithPageKeyResult> call(
    SearchCourseReviewsWithPageKeyParams params,
  ) async {
    return _repo.searchCourseReviewsWithPageKey(
      author: params.author,
      courseName: params.courseName,
      comments: params.content,
      pageKey: params.pageKey,
      tags: params.tags,
    );
  }
}

class SearchCourseReviewsWithPageKeyParams extends Equatable {
  const SearchCourseReviewsWithPageKeyParams({
    required this.author,
    required this.courseName,
    required this.content,
    required this.pageKey,
    this.tags = const [],
  });

  const SearchCourseReviewsWithPageKeyParams.empty()
      : author = '',
        courseName = '',
        content = '',
        pageKey = 0,
        tags = const [];

  final String author;
  final String courseName;
  final String content;
  final int pageKey;
  final List<String> tags;

  @override
  List<Object?> get props => [author, courseName, content, pageKey, tags];
}

class SearchCourseReviewsWithPageKeyResult extends Equatable {
  const SearchCourseReviewsWithPageKeyResult({
    required this.reviews,
    required this.pageKey,
    this.nextPageKey,
  });

  final List<CourseReview> reviews;
  final int pageKey;
  final int? nextPageKey;

  @override
  List<Object?> get props => [reviews, pageKey, nextPageKey];
}
