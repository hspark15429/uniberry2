import 'package:equatable/equatable.dart';
import 'package:uniberry/core/usecases/usecases.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/timetable/domain/repository/timetable_repository.dart';

class SearchCourses
    implements UsecaseWithParams<List<String>, SearchCoursesParams> {
  const SearchCourses(this._repo);

  final TimetableRepository _repo;

  @override
  ResultFuture<List<String>> call(SearchCoursesParams params) async {
    final courses = await _repo.searchCourses(
      query: params.query ?? '',
      school: params.school ?? '',
      campus: params.campus ?? '',
      term: params.term ?? '',
      period: params.period ?? '',
    );
    return courses;
  }
}

class SearchCoursesParams extends Equatable {
  const SearchCoursesParams({
    this.query,
    this.school,
    this.campus,
    this.term,
    this.period,
  });

  const SearchCoursesParams.empty()
      : this(
          query: 'empty.query',
          school: 'empty.school',
          campus: 'empty.campus',
          term: 'empty.term',
          period: 'empty.period',
        );

  final String? query;
  final String? school;
  final String? campus;
  final String? term;
  final String? period;

  @override
  List<String?> get props => [query, school, campus, term, period];
}
