import 'package:equatable/equatable.dart';
import 'package:uniberry2/core/utils/typedefs.dart';

class Course extends Equatable {
  const Course({
    required this.courseId,
    required this.titles,
    required this.syllabusUrl,
    required this.schools,
    required this.codes,
    required this.term,
    required this.periods,
    required this.campuses,
    required this.professors,
    required this.languages,
    required this.credit,
  });

  final String courseId;
  final List<String> titles;
  final String syllabusUrl;
  final List<String> schools;
  final List<String> codes;
  final String term;
  final List<String> periods;
  final List<String> campuses;
  final List<String> professors;
  final List<String> languages;
  final int credit;

  const Course.empty()
      : courseId = '',
        titles = const [],
        syllabusUrl = '',
        schools = const [],
        codes = const [],
        term = '',
        periods = const [],
        campuses = const [],
        professors = const [],
        languages = const [],
        credit = 0;

  @override
  List<Object> get props => [courseId];

  @override
  String toString() =>
      'Course(courseId: $courseId, titles: $titles, syllabusUrl: $syllabusUrl, '
      'schools: $schools, codes: $codes, term: $term, periods: $periods, '
      'campuses: $campuses, professors: $professors, languages: $languages, '
      'credit: $credit)';
}
