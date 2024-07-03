import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/domain/entities/course_review.dart';
import 'package:uniberry/src/forum/domain/repository/course_review_repository.dart';

class GetCourseReviewsAll implements UsecaseWithoutParams<List<CourseReview>> {
  const GetCourseReviewsAll(this._repo);

  final CourseReviewRepository _repo;

  @override
  ResultFuture<List<CourseReview>> call() async {
    return _repo.getCourseReviewsAll();
  }
}
