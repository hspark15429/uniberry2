import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.code,
    required super.title,
    required super.professor,
  });

  const CourseModel.empty()
      : this(
          code: '',
          title: '',
          professor: '',
        );

  // frommap
  CourseModel.fromMap(DataMap map)
      : this(
          code: map['code'] as String,
          title: map['title'] as String,
          professor: map['professor'] as String,
        );

  // tomap
  DataMap toMap() {
    return {
      'code': code,
      'title': title,
      'professor': professor,
    };
  }

  //copywith
  CourseModel copyWith({
    String? code,
    String? title,
    String? professor,
  }) {
    return CourseModel(
      code: code ?? this.code,
      title: title ?? this.title,
      professor: professor ?? this.professor,
    );
  }
}
