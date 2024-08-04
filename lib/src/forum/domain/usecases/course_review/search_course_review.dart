import 'package:equatable/equatable.dart';
import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';

import 'package:uniberry/src/forum/domain/repository/course_review_repository.dart';

class SearchCourseReviews
    implements UsecaseWithParams<List<String>, SearchCourseReviewsParams> {
  const SearchCourseReviews(this._repo);

  final CourseReviewRepository _repo;

  @override
  ResultFuture<List<String>> call(SearchCourseReviewsParams params) async {
    final result = await _repo.searchCourseReviews(
      author: params.author,
      title: params.title,
      comments: params.content,
      courseName: '',
    );
    return result;
  }
}

class SearchCourseReviewsParams extends Equatable {
  const SearchCourseReviewsParams({
    required this.title,
    required this.content,
    required this.author,
    required String courseName,
    required String comments,
  });

  const SearchCourseReviewsParams.empty()
      : title = '',
        content = '',
        author = '';

  final String title;
  final String content;
  final String author;

  @override
  List<Object?> get props => [title, content, author];
}
