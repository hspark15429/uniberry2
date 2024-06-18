import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/core/providers/user_provider.dart';
import 'package:uniberry2/src/comment/domain/entities/comment.dart';
import 'package:uniberry2/src/comment/presentation/cubit/comment_cubit.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    required this.comment,
    super.key,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(comment.content),
      subtitle: Text(comment.author),
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