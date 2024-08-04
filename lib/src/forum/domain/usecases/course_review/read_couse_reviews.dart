import 'package:dartz/dartz.dart';
import 'package:uniberry/core/errors/failures.dart';
import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/domain/entities/course_review.dart';
import 'package:uniberry/src/forum/domain/repository/course_review_repository.dart';

class ReadCourseReviews
    implements UsecaseWithParams<List<CourseReview>, List<String>> {
  const ReadCourseReviews(this._repo);

  final CourseReviewRepository _repo;

  @override
  ResultFuture<List<CourseReview>> call(List<String> ids) async {
    return _repo.readCourseReviews(ids);
  }
}
