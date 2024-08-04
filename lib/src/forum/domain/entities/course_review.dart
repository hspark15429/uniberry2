import 'package:equatable/equatable.dart';

class CourseReview extends Equatable {
  const CourseReview({
    required this.reviewId,
    required this.courseName,
    required this.instructorName,
    required this.department,
    required this.year,
    required this.term,
    required this.attendanceMethod,
    required this.evaluationMethods,
    required this.contentSatisfaction,
    required this.atmosphere,
    required this.comments,
    required this.author,
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
  });

  final String reviewId;
  final String courseName;
  final String instructorName;
  final String department;
  final String year;
  final String term;
  final String attendanceMethod;
  final List<String> evaluationMethods;
  final int contentSatisfaction;
  final String atmosphere;
  final String comments;
  final String author;
  final String uid;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object> get props => [
        reviewId,
        courseName,
        instructorName,
        department,
        year,
        term,
        attendanceMethod,
        evaluationMethods,
        contentSatisfaction,
        atmosphere,
        comments,
        author,
        uid,
        createdAt,
        updatedAt
      ];
}
