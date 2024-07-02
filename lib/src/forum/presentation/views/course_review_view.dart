import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry/core/common/views/loading_view.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/services/injection_container.dart';
import 'package:uniberry/core/utils/core_utils.dart';
import 'package:uniberry/src/forum/domain/entities/course_review.dart';
import 'package:uniberry/src/forum/presentation/cubit/course_review_cubit.dart';
import 'package:uniberry/src/forum/presentation/views/course_review_details_view.dart';

class CourseReviewView extends StatelessWidget {
  const CourseReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user!;
    return BlocProvider(
      create: (context) =>
          sl<CourseReviewCubit>()..getCourseReviewsByUserId(user.uid),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('授業レビュー'),
        ),
        body: BlocConsumer<CourseReviewCubit, CourseReviewState>(
          listener: (context, state) {
            if (state is CourseReviewError) {
              CoreUtils.showSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is CourseReviewLoading) {
              return const LoadingView();
            } else if (state is CourseReviewsRead) {
              return ListView.builder(
                itemCount: state.reviews.length,
                itemBuilder: (context, index) {
                  final review = state.reviews[index];
                  return ListTile(
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
                  );
                },
              );
            } else if (state is CourseReviewError) {
              return Center(
                child: Text('오류 발생: ${state.message}'),
              );
            }
            return Center(
              child: Text('No reviews available.'),
            );
          },
        ),
      ),
    );
  }
}
