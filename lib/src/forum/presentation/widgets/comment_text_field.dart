import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/src/comment/data/models/comment_model.dart';
import 'package:uniberry/src/comment/domain/entities/comment.dart';
import 'package:uniberry/src/comment/presentation/cubit/comment_cubit.dart';
import 'package:uniberry/src/forum/presentation/views/post_details_view.dart';

class CommentTextField extends StatelessWidget {
  const CommentTextField({
    required this.commentContentController,
    required this.replyCommentController,
    required this.widget,
    super.key,
  });

  final TextEditingController commentContentController;
  final PostDetailsView widget;
  final ValueNotifier<Comment?> replyCommentController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      maxLines: null,
      controller: commentContentController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: const Icon(
            IconlyBold.arrow_up_square,
            color: Colors.black,
          ),
          onPressed: () {
            final user = context.read<UserProvider>().user;
            if (commentContentController.text.trim().isNotEmpty) {
              context.read<CommentCubit>().createComment(
                    CommentModel(
                      commentId: '_new.CommentId',
                      content: commentContentController.text,
                      postId: widget.post.postId,
                      author: user!.fullName,
                      uid: user.uid,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                      parentCommentId: (replyCommentController.value != null)
                          ? replyCommentController.value!.commentId
                          : null,
                    ),
                  );
            }
          },
        ),
        hintText: 'Comment',
      ),
    );
  }
}
