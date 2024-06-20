import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:uniberry/core/common/views/loading_view.dart';
import 'package:uniberry/core/extensions/date_time_extensions.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/services/injection_container.dart';
import 'package:uniberry/src/comment/domain/entities/comment.dart';
import 'package:uniberry/src/comment/presentation/cubit/comment_cubit.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    required this.comment,
    required this.replyCommentController,
    super.key,
  });

  final Comment comment;
  final ValueNotifier<Comment?> replyCommentController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(comment.content),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                    '${comment.author}#${comment.uid.trim().substring(0, 5)} (${comment.createdAt.timeAgo})'),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  // reply to comment
                  replyCommentController.value = comment;
                },
                icon: const Icon(
                  IconlyBold.chat,
                  size: 20,
                ),
              ),
              if (comment.uid == context.read<UserProvider>().user!.uid)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // delete comment
                    context
                        .read<CommentCubit>()
                        .deleteComment(comment.commentId);
                  },
                )
            ],
          ),
        ),
        BlocProvider(
          create: (context) => sl<CommentCubit>(),
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: BlocConsumer<CommentCubit, CommentState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is CommentInitial || state is CommentDeleted) {
                  context.read<CommentCubit>().getCommentsByParentCommentId(
                        comment.commentId,
                      );
                  return const LoadingView();
                } else if (state is CommentLoading) {
                  return const LoadingView();
                } else if (state is CommentError) {
                  return const Text('Error');
                } else if (state is CommentsFetched) {
                  final comments = state.comments;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return CommentCard(
                        comment: comments[index],
                        replyCommentController: replyCommentController,
                      );
                    },
                  );
                } else {
                  // debugPrint(state.toString());
                  return const LoadingView();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
