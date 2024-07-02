import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:uniberry/core/common/widgets/title_text.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/services/injection_container.dart';
import 'package:uniberry/core/utils/core_utils.dart';
import 'package:uniberry/src/forum/domain/entities/course_review.dart';
import 'package:uniberry/src/forum/presentation/cubit/course_review_cubit.dart';

class CourseReviewDetailsView extends StatefulWidget {
  const CourseReviewDetailsView(this.review, {super.key});

  final CourseReview review;

  static const String id = '/course-review-details';

  @override
  State<CourseReviewDetailsView> createState() =>
      _CourseReviewDetailsViewState();
}

class _CourseReviewDetailsViewState extends State<CourseReviewDetailsView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CourseReviewCubit>(),
      child: BlocConsumer<CourseReviewCubit, CourseReviewState>(
        listener: (context, state) {
          if (state is CourseReviewDeleted) {
            Navigator.pop(context);
            CoreUtils.showSnackBar(context, '削除されました.');
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('授業レビュー詳細'),
              actions: [
                if (context.read<UserProvider>().user!.uid == widget.review.uid)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      CoreUtils.showConfirmationDialog(
                        context,
                        text: '削除',
                        title: 'レビューを削除',
                        content: '授業レビューを削除します',
                        actionText: '削除',
                        cancelText: 'キャンセル',
                      ).then((value) {
                        if (value != null && value) {
                          context
                              .read<CourseReviewCubit>()
                              .deleteCourseReview(widget.review.reviewId);
                        }
                      });
                    },
                  ),
              ],
              backgroundColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 18),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildDetailRow('講義名', widget.review.courseName),
                      const SizedBox(height: 16),
                      _buildDetailRow('投稿者', widget.review.author),
                      _buildDetailRow('専攻', widget.review.department),
                      _buildDetailRow('受講時期', widget.review.year),
                      _buildDetailRow('出欠確認方法', widget.review.attendanceMethod),
                      _buildDetailRow(
                          '成績評価方法', widget.review.evaluationMethods.join(' ')),
                      _buildStarRatingRow(
                          '授業の満足度', widget.review.contentSatisfaction),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'コメント',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            widget.review.createdAt
                                .toLocal()
                                .toString()
                                .substring(0, 16),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.review.comments,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRatingRow(String label, int rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.deepPurple,
              );
            }),
          ),
        ],
      ),
    );
  }
}
