import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:uniberry2/core/common/views/loading_view.dart';
import 'package:uniberry2/core/common/widgets/i_field.dart';
import 'package:uniberry2/core/enums/update_post_enum.dart';
import 'package:uniberry2/core/providers/user_provider.dart';
import 'package:uniberry2/core/utils/core_utils.dart';
import 'package:uniberry2/src/comment/data/models/comment_model.dart';
import 'package:uniberry2/src/comment/presentation/cubit/comment_cubit.dart';
import 'package:uniberry2/src/comment/presentation/widgets/comment_card.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';
import 'package:uniberry2/src/forum/presentation/cubit/post_cubit.dart';

class PostDetailsView extends StatefulWidget {
  const PostDetailsView(this.post, {super.key});

  final Post post;

  static const String id = '/post-details';

  @override
  State<PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends State<PostDetailsView> {
  final commentContentController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<CommentCubit>().getCommentsByPostId(widget.post.postId);
  }

  @override
  void dispose() {
    commentContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.post.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.post.content!,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      widget.post.author,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Spacer(),
                    // icon showing comment count
                    const Icon(
                      IconlyBold.chat,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.post.commentCount.toString(),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: BlocConsumer<CommentCubit, CommentState>(
                listener: (context, state) {
                  if (state is CommentCreated || state is CommentDeleted) {
                    commentContentController.clear();
                    context
                        .read<CommentCubit>()
                        .getCommentsByPostId(widget.post.postId);

                    CoreUtils.showSnackBar(
                      context,
                      'Operation was successful!',
                    );
                  }
                },
                builder: (context, state) {
                  if (state is CommentsFetchedByPostId) {
                    return ListView.builder(
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
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: IField(
              controller: commentContentController,
              hintText: 'Comment',
              suffixIcon: IconButton(
                icon: const Icon(IconlyBold.arrow_up_square),
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
                          ),
                        );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
