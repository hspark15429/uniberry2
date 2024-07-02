import 'package:flutter/material.dart';
import 'package:uniberry/src/forum/presentation/widgets/add_course_review_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AddCourseReviewView extends StatelessWidget {
  const AddCourseReviewView({super.key, this.reviewId});

  final String? reviewId;

  static const String id = '/add-course-review';

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final departmentController = TextEditingController();
    final yearController = TextEditingController();
    final gradeController = TextEditingController();
    final attendanceController = TextEditingController();
    final evaluationController = TextEditingController();
    final commentController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final tagController = ValueNotifier<int>(0);
    final user = context.read<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('강의 리뷰 작성'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newReview = {
                  'reviewId': reviewId ?? '',
                  'courseName': titleController.text,
                  'instructorName': contentController.text,
                  'department': departmentController.text,
                  'year': yearController.text,
                  'term': '봄',
                  'attendanceMethod': attendanceController.text,
                  'evaluationMethods': evaluationController.text.split(','),
                  'contentSatisfaction': tagController.value,
                  'atmosphere': '全て対面',
                  'comments': commentController.text,
                  'author': user?.fullName ?? 'Anonymous',
                  'uid': user?.uid ?? '',
                  'createdAt': FieldValue.serverTimestamp(),
                  'updatedAt': FieldValue.serverTimestamp(),
                };
                FirebaseFirestore.instance
                    .collection('course_reviews')
                    .add(newReview) // 자동으로 ID 생성
                    .then((_) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Review saved successfully')),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save review: $error')),
                  );
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AddCourseReviewForm(
          titleController: titleController,
          contentController: contentController,
          departmentController: departmentController,
          yearController: yearController,
          gradeController: gradeController,
          attendanceController: attendanceController,
          evaluationController: evaluationController,
          commentController: commentController,
          formKey: formKey,
          tagController: tagController,
        ),
      ),
    );
  }
}
