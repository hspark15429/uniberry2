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

    void saveReview() {
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
          .add(newReview)
          .then((docRef) {
        docRef.update({'reviewId': docRef.id}).then((_) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'レビューを作成しました',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
            ),
          );
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save review: $error',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '授業レビュー作成',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                saveReview();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      '必須項目を埋めてください',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.white,
                  ),
                );
              }
            },
            child: const Text(
              '投稿する',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
          onSave: saveReview,
        ),
      ),
    );
  }
}
