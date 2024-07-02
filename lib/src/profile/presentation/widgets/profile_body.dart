import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uniberry/core/common/views/loading_view.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/services/injection_container.dart';
import 'package:uniberry/core/utils/core_utils.dart';
import 'package:uniberry/src/comment/domain/entities/comment.dart';
import 'package:uniberry/src/comment/presentation/cubit/comment_cubit.dart';
import 'package:uniberry/src/comment/presentation/widgets/comment_card.dart';
import 'package:uniberry/src/forum/presentation/cubit/post_cubit.dart';
import 'package:uniberry/src/forum/presentation/views/post_details_view.dart';
import 'package:uniberry/src/forum/presentation/widgets/post_card.dart';
import 'package:uniberry/src/forum/presentation/cubit/course_review_cubit.dart';
import 'package:uniberry/src/forum/presentation/widgets/course_review_card.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  final options = ['作成した投稿', '作成したコメント', '作成した授業レビュー'];
  int _index = 0;
  int get index => _index;
  set index(int value) {
    setState(() {
      _index = value;
      _loadPosts();
      _loadComments();
      _loadCourseReviews(); // 강의 리뷰 로드 추가
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _loadComments();
    _loadCourseReviews(); // 강의 리뷰 로드 추가
  }

  void _loadPosts() {
    context.read<PostCubit>().getPostsByUserId(
          context.read<UserProvider>().user!.uid,
        );
  }

  void _loadComments() {
    context.read<CommentCubit>().getCommentsByUserId(
          context.read<UserProvider>().user!.uid,
        );
  }

  void _loadCourseReviews() {
    context.read<CourseReviewCubit>().getCourseReviewsByUserId(
          context.read<UserProvider>().user!.uid,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: Text(options[0]),
                    selected: index == 0,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) index = 0;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(options[1]),
                    selected: index == 1,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) index = 1;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(options[2]),
                    selected: index == 2,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) index = 2;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (index == 0)
              BlocConsumer<PostCubit, PostState>(
                listener: (context, state) {
                  if (state is PostInitial || state is PostDeleted) {
                    context.read<PostCubit>().getPostsByUserId(
                          context.read<UserProvider>().user!.uid,
                        );
                  }
                },
                builder: (context, state) {
                  if (state is PostsRead) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return PostCard(post: post);
                      },
                    );
                  }

                  return const LoadingView();
                },
              ),
            if (index == 1)
              BlocConsumer<CommentCubit, CommentState>(
                listener: (context, state) {
                  if (state is CommentInitial || state is CommentDeleted) {
                    context.read<CommentCubit>().getCommentsByUserId(
                          context.read<UserProvider>().user!.uid,
                        );
                  }
                },
                builder: (context, state) {
                  if (state is CommentsFetched) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.comments.length,
                      itemBuilder: (context, index) {
                        final comment = state.comments[index];
                        return BlocProvider(
                          create: (context) => sl<PostCubit>(),
                          child: Builder(
                            builder: (context) {
                              return BlocConsumer<PostCubit, PostState>(
                                listener: (context, state) {
                                  if (state is PostRead) {
                                    Navigator.pushNamed(
                                      context,
                                      PostDetailsView.id,
                                      arguments: state.post,
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return GestureDetector(
                                    onTap: () {
                                      context.read<PostCubit>().readPost(
                                            comment.postId,
                                          );
                                    },
                                    child: CommentCard(
                                      comment: comment,
                                      replyCommentController:
                                          ValueNotifier<Comment?>(null),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  }

                  return const LoadingView();
                },
              ),
            if (index == 2)
              BlocConsumer<CourseReviewCubit, CourseReviewState>(
                listener: (context, state) {
                  if (state is CourseReviewError) {
                    CoreUtils.showSnackBar(context, state.message);
                  }
                },
                builder: (context, state) {
                  if (state is CourseReviewsRead) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.reviews.length,
                      itemBuilder: (context, index) {
                        final review = state.reviews[index];
                        return CourseReviewCard(review: review);
                      },
                    );
                  }

                  return const LoadingView();
                },
              ),
          ],
        );
      },
    );
  }
}
