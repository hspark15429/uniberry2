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
      create: (context) => sl<CourseReviewCubit>()..getCourseReviewsAll(),
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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: state.reviews.length,
                  itemBuilder: (context, index) {
                    final review = state.reviews[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CourseReviewDetailsView(review),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.courseName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                review.instructorName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    index < review.contentSatisfaction
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.deepPurple,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                review.atmosphere,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is CourseReviewError) {
              return Center(
                child: Text('오류 발생: ${state.message}'),
              );
            }
            return const Center(
              child: Text('No reviews available.'),
            );
          },
        ),
      ),
    );
  }
}
