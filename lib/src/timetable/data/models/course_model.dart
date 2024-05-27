import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.courseId,
    required super.titles,
    required super.syllabusUrl,
    required super.schools,
    required super.codes,
    required super.term,
    required super.periods,
    required super.campuses,
    required super.professors,
    required super.languages,
    required super.credit,
  });

  const CourseModel.empty()
      : this(
          courseId: '',
          titles: const [],
          syllabusUrl: '',
          schools: const [],
          codes: const [],
          term: '',
          periods: const [],
          campuses: const [],
          professors: const [],
          languages: const [],
          credit: 0,
        );

  CourseModel.fromMap(DataMap map)
      : this(
          courseId: map['courseId'] as String,
          titles: List<String>.from(map['titles'] as List<dynamic>),
          syllabusUrl: map['syllabusUrl'] as String,
          schools: List<String>.from(map['schools'] as List<dynamic>),
          codes: List<String>.from(map['codes'] as List<dynamic>),
          term: map['term'] as String,
          periods: List<String>.from(map['periods'] as List<dynamic>),
          campuses: List<String>.from(map['campuses'] as List<dynamic>),
          professors: List<String>.from(map['professors'] as List<dynamic>),
          languages: List<String>.from(map['languages'] as List<dynamic>),
          credit: (map['credit'] as num).toInt(),
        );

  DataMap toMap() {
    return {
      'courseId': courseId,
      'titles': titles,
      'syllabusUrl': syllabusUrl,
      'schools': schools,
      'codes': codes,
      'term': term,
      'periods': periods,
      'campuses': campuses,
      'professors': professors,
      'languages': languages,
      'credit': credit,
    };
  }

  CourseModel copyWith({
    String? courseId,
    List<String>? titles,
    String? syllabusUrl,
    List<String>? schools,
    List<String>? codes,
    String? term,
    List<String>? periods,
    List<String>? campuses,
    List<String>? professors,
    List<String>? languages,
    int? credit,
  }) {
    return CourseModel(
      courseId: courseId ?? this.courseId,
      titles: titles ?? this.titles,
      syllabusUrl: syllabusUrl ?? this.syllabusUrl,
      schools: schools ?? this.schools,
      codes: codes ?? this.codes,
      term: term ?? this.term,
      periods: periods ?? this.periods,
      campuses: campuses ?? this.campuses,
      professors: professors ?? this.professors,
      languages: languages ?? this.languages,
      credit: credit ?? this.credit,
    );
  }
}
