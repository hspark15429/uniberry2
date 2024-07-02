import 'package:flutter/material.dart';
import 'package:uniberry/src/forum/domain/entities/course_review.dart';
import 'package:uniberry/src/forum/presentation/views/course_review_details_view.dart';

class CourseReviewCard extends StatelessWidget {
  const CourseReviewCard({required this.review, Key? key}) : super(key: key);

  final CourseReview review;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(review.courseName),
        subtitle: Text(review.instructorName),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseReviewDetailsView(review),
            ),
          );
        },
      ),
    );
  }
}
