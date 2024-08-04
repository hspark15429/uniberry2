import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:uniberry/core/common/views/loading_view.dart';
import 'package:uniberry/core/common/widgets/flag_button.dart';
import 'package:uniberry/core/extensions/date_time_extensions.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/services/injection_container.dart';
import 'package:uniberry/core/utils/constants.dart';
import 'package:uniberry/src/auth/domain/entities/user.dart';
import 'package:uniberry/src/comment/domain/entities/comment.dart';
import 'package:uniberry/src/comment/presentation/cubit/comment_cubit.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({
    required this.comment,
    required this.replyCommentController,
    super.key,
  });

  final Comment comment;
  final ValueNotifier<Comment?> replyCommentController;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  late LocalUser user;

  @override
  void initState() {
    super.initState();
    user = context.read<UserProvider>().user!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: user.blockedUids.contains(widget.comment.uid)
              ? const Text(kBlockedContent)
              : Text(widget.comment.content),
          subtitle: Row(
            children: [
              Expanded(
                child: user.blockedUids.contains(widget.comment.uid)
                    ? const Text(kBlockedContent)
                    : Text(
                        '${widget.comment.author}#${widget.comment.uid.trim().substring(0, 5)} (${widget.comment.createdAt.timeAgo})'),
              ),
              const SizedBox(width: 8),
              if (!(widget.comment.uid ==
                  context.read<UserProvider>().user!.uid))
                FlagButton(item: widget.comment),
              if (!user.blockedUids.contains(widget.comment.uid))
                IconButton(
                  onPressed: () {
                    // reply to comment
                    widget.replyCommentController.value = widget.comment;
                  },
                  icon: const Icon(
                    IconlyBold.chat,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
              if (widget.comment.uid == context.read<UserProvider>().user!.uid)
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red[600],
                  onPressed: () {
                    // delete comment
                    context
                        .read<CommentCubit>()
                        .deleteComment(widget.comment.commentId);
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
                        widget.comment.commentId,
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
                        replyCommentController: widget.replyCommentController,
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
