import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:uniberry/core/common/views/loading_view.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/utils/core_utils.dart';
import 'package:uniberry/src/comment/domain/entities/comment.dart';
import 'package:uniberry/src/comment/presentation/cubit/comment_cubit.dart';
import 'package:uniberry/src/comment/presentation/widgets/comment_card.dart';
import 'package:uniberry/src/forum/domain/entities/post.dart';
import 'package:uniberry/src/forum/presentation/cubit/post_cubit.dart';
import 'package:intl/intl.dart';
import 'package:uniberry/src/forum/presentation/widgets/comment_text_field.dart';

class PostDetailsView extends StatefulWidget {
  const PostDetailsView(this.post, {super.key});

  final Post post;

  static const String id = '/post-details';

  @override
  State<PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends State<PostDetailsView> {
  final commentContentController = TextEditingController();
  final replyCommentController = ValueNotifier<Comment?>(null);
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    commentContentController.addListener(_handleTextChange);
    context.read<CommentCubit>().getCommentsByPostId(widget.post.postId);
  }

  @override
  void dispose() {
    commentContentController
      ..removeListener(_handleTextChange)
      ..dispose();
    replyCommentController.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final comment = replyCommentController.value;
    if (comment != null) {
      final authorTag = '@${comment.author}';
      if (!commentContentController.text.contains(authorTag)) {
        replyCommentController.value = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostDeleted) {
          Navigator.pop(context);
          CoreUtils.showSnackBar(context, '게시물이 삭제되었습니다.');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.post.title),
            actions: [
              if (context.read<UserProvider>().user!.uid == widget.post.uid)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    CoreUtils.showConfirmationDialog(
                      context,
                      text: 'delete',
                      title: '삭제 확인',
                      content: '게시물이 삭제됩니다. 계속하시겠습니까?',
                      actionText: '삭제',
                      cancelText: '취소',
                    ).then((value) {
                      if (value != null && value) {
                        context
                            .read<PostCubit>()
                            .deletePost(widget.post.postId);
                      }
                    });
                  },
                ),
            ],
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          body: ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          '#${widget.post.tags![0]}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.orange,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.post.createdAt
                              .toLocal()
                              .toString()
                              .substring(0, 16),
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.post.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (widget.post.type == 'text')
                      Text(
                        widget.post.content!,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      )
                    else if (widget.post.type == 'image')
                      Image.network(
                        widget.post.content!,
                        fit: BoxFit.cover,
                      )
                    else if (widget.post.type == 'link')
                      AnyLinkPreview(
                        link: widget.post.link!,
                        displayDirection: UIDirection.uiDirectionHorizontal,
                        showMultimedia: true,
                        bodyMaxLines: 5,
                        bodyTextOverflow: TextOverflow.ellipsis,
                        titleStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        bodyStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        errorBody: '내용 미리보기가 없습니다.',
                        errorTitle: '제목 미리보기가 없습니다.',
                        errorWidget: Container(
                          color: Colors.grey[300],
                          child: const Text('Oops!'),
                        ),
                        errorImage: "https://google.com/",
                        cache: const Duration(days: 7),
                        backgroundColor: Colors.grey[300],
                        borderRadius: 12,
                        removeElevation: false,
                        boxShadow: const [
                          BoxShadow(blurRadius: 3, color: Colors.grey)
                        ],
                      ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.post.author,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(
                              IconlyBold.chat,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.post.commentCount.toString(),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey[300],
                thickness: 1,
                height: 32,
                indent: 16,
                endIndent: 16,
              ),
              BlocConsumer<CommentCubit, CommentState>(
                listener: (context, state) {
                  if (state is CommentCreated || state is CommentDeleted) {
                    commentContentController.clear();
                    context
                        .read<CommentCubit>()
                        .getCommentsByPostId(widget.post.postId);

                    CoreUtils.showSnackBar(
                        context, 'Operation was successful!');
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
                        return CommentCard(
                          comment: comment,
                          replyCommentController: replyCommentController,
                        );
                      },
                    );
                  }
                  return const LoadingView();
                },
              ),
            ],
          ),
          bottomNavigationBar: ValueListenableBuilder(
              valueListenable: replyCommentController,
              builder: (context, Comment? comment, child) {
                if (comment != null) {
                  commentContentController.text = '@${comment.author} ';
                } else {
                  commentContentController.clear();
                }
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: formKey,
                    child: CommentTextField(
                      commentContentController: commentContentController,
                      replyCommentController: replyCommentController,
                      widget: widget,
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
