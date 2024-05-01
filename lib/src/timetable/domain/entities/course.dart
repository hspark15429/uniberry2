import 'package:equatable/equatable.dart';

class Course extends Equatable {
  const Course({
    required this.code,
    required this.title,
    required this.professor,
  });

  final String code;
  final String title;
  final String professor;

  const Course.empty()
      : this(
          code: '',
          title: '',
          professor: '',
        );

  @override
  List<Object> get props => [code, title];

  @override
  String toString() =>
      'Course(code: $code, title: $title, professor: $professor)';
}
