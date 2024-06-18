import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uniberry2/core/common/views/loading_view.dart';
import 'package:uniberry2/core/providers/user_provider.dart';
import 'package:uniberry2/src/comment/presentation/cubit/comment_cubit.dart';
import 'package:uniberry2/src/comment/presentation/widgets/comment_card.dart';
import 'package:uniberry2/src/forum/presentation/cubit/post_cubit.dart';
import 'package:uniberry2/src/forum/presentation/widgets/post_card.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  final options = ['내가 작성한 글', '내가 작성한 댓글'];
  int index = 0;

  @override
  void initState() {
    super.initState();
    context.read<CommentCubit>().getCommentsByUserId(
          context.read<UserProvider>().user!.uid,
        );
    context.read<PostCubit>().getPostsByUserId(
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
            Row(
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
              ],
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
                        return CommentCard(comment: comment);
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
