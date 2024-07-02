import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/domain/entities/course_review.dart';
import 'package:uniberry/src/forum/domain/repository/course_review_repository.dart';

class GetCourseReviewsByUserId
    implements UsecaseWithParams<List<CourseReview>, String> {
  const GetCourseReviewsByUserId(this._repo);

  final CourseReviewRepository _repo;

  @override
  ResultFuture<List<CourseReview>> call(String userId) async {
    return _repo.getCourseReviewsByUserId(userId);
  }
}
