import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/src/comment/domain/entities/comment.dart';
import 'package:uniberry/src/comment/presentation/cubit/comment_cubit.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    required this.comment,
    super.key,
  });

  final Comment comment;

  String formatCommentTime(DateTime commentTime) {
    final now = DateTime.now();
    final difference = now.difference(commentTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}초 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else {
      return DateFormat('yyyy-MM-dd HH:mm').format(commentTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(comment.content),
      subtitle: Text('${comment.author}#${comment.uid.trim().substring(0, 5)}'),
      trailing: (comment.uid == context.read<UserProvider>().user!.uid)
          ? IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // delete comment
                context.read<CommentCubit>().deleteComment(comment.commentId);
              },
            )
          : null,
    );
  }
}
