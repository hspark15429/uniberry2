import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/domain/repository/course_review_repository.dart';

class DeleteCourseReview implements UsecaseWithParams<void, String> {
  DeleteCourseReview(this._repo);

  final CourseReviewRepository _repo;

  @override
  ResultFuture<void> call(String reviewId) async {
    return _repo.deleteCourseReview(reviewId);
  }
}
