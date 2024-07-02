import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/domain/entities/course_review.dart';

class CourseReviewModel extends CourseReview {
  const CourseReviewModel({
    required super.reviewId,
    required super.courseName,
    required super.instructorName,
    required super.department,
    required super.year,
    required super.term,
    required super.attendanceMethod,
    required super.evaluationMethods,
    required super.contentSatisfaction,
    required super.atmosphere,
    required super.comments,
    required super.author,
    required super.uid,
    required super.createdAt,
    required super.updatedAt,
  });

  CourseReviewModel.empty([DateTime? date])
      : this(
          reviewId: '_empty.reviewId',
          courseName: '_empty.courseName',
          instructorName: '_empty.instructorName',
          department: '_empty.department',
          year: '_empty.year',
          term: '_empty.term',
          attendanceMethod: '_empty.attendanceMethod',
          evaluationMethods: ['_empty.evaluationMethod'],
          contentSatisfaction: 0,
          atmosphere: '_empty.atmosphere',
          comments: '_empty.comment',
          author: '_empty.author',
          uid: '_empty.uid',
          createdAt: date ?? DateTime.now(),
          updatedAt: date ?? DateTime.now(),
        );

  CourseReviewModel.fromMap(DataMap map)
      : this(
          reviewId: map['reviewId'] as String,
          courseName: map['courseName'] as String,
          instructorName: map['instructorName'] as String,
          department: map['department'] as String,
          year: map['year'] as String,
          term: map['term'] as String,
          attendanceMethod: map['attendanceMethod'] as String,
          evaluationMethods:
              (map['evaluationMethods'] as List<dynamic>).cast<String>(),
          contentSatisfaction: map['contentSatisfaction'] as int,
          atmosphere: map['atmosphere'] as String,
          comments: map['comments'] as String,
          author: map['author'] as String,
          uid: map['uid'] as String,
          createdAt: (map['createdAt'] as Timestamp).toDate(),
          updatedAt: (map['updatedAt'] as Timestamp).toDate(),
        );

  CourseReviewModel.fromJson(Map<String, dynamic> json)
      : this(
          reviewId: json['reviewId'] as String,
          courseName: json['courseName'] as String,
          instructorName: json['instructorName'] as String,
          department: json['department'] as String,
          year: json['year'] as String,
          term: json['term'] as String,
          attendanceMethod: json['attendanceMethod'] as String,
          evaluationMethods:
              (json['evaluationMethods'] as List<dynamic>).cast<String>(),
          contentSatisfaction: json['contentSatisfaction'] as int,
          atmosphere: json['atmosphere'] as String,
          comments: json['comments'] as String,
          author: json['author'] as String,
          uid: json['uid'] as String,
          createdAt: DateTime.fromMillisecondsSinceEpoch(
              (json['createdAt'] as int) * 1000),
          updatedAt: DateTime.fromMillisecondsSinceEpoch(
              (json['updatedAt'] as int) * 1000),
        );

  DataMap toMap() {
    return {
      'reviewId': reviewId,
      'courseName': courseName,
      'instructorName': instructorName,
      'department': department,
      'year': year,
      'term': term,
      'attendanceMethod': attendanceMethod,
      'evaluationMethods': evaluationMethods,
      'contentSatisfaction': contentSatisfaction,
      'atmosphere': atmosphere,
      'comments': comments,
      'author': author,
      'uid': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  CourseReviewModel copyWith({
    String? reviewId,
    String? courseName,
    String? instructorName,
    String? department,
    String? year,
    String? term,
    String? attendanceMethod,
    List<String>? evaluationMethods,
    int? contentSatisfaction,
    String? atmosphere,
    String? comments,
    String? author,
    String? uid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseReviewModel(
      reviewId: reviewId ?? this.reviewId,
      courseName: courseName ?? this.courseName,
      instructorName: instructorName ?? this.instructorName,
      department: department ?? this.department,
      year: year ?? this.year,
      term: term ?? this.term,
      attendanceMethod: attendanceMethod ?? this.attendanceMethod,
      evaluationMethods: evaluationMethods ?? this.evaluationMethods,
      contentSatisfaction: contentSatisfaction ?? this.contentSatisfaction,
      atmosphere: atmosphere ?? this.atmosphere,
      comments: comments ?? this.comments,
      author: author ?? this.author,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
