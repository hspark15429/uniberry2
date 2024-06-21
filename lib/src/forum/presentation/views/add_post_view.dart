import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uniberry/core/common/providers/tab_navigator.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/utils/constants.dart';
import 'package:uniberry/core/utils/core_utils.dart';
import 'package:uniberry/src/auth/domain/entities/user.dart';
import 'package:uniberry/src/forum/data/models/post_model.dart';
import 'package:uniberry/src/forum/presentation/cubit/post_cubit.dart';
import 'package:uniberry/src/forum/presentation/widgets/add_post_form.dart';

class AddPostView extends StatefulWidget {
  const AddPostView({super.key});

  static const id = '/post/create';

  @override
  State<AddPostView> createState() => _AddPostViewState();
}

class _AddPostViewState extends State<AddPostView> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final linkController = TextEditingController();
  final tagController = ValueNotifier<int>(1);
  final typeController = ValueNotifier<int>(0);
  final imageController = ValueNotifier<dynamic>(null);
  final formKey = GlobalKey<FormState>();

  late LocalUser user;

  @override
  void initState() {
    user = context.read<UserProvider>().user!;
    titleController.text = '';
    contentController.text = '';
    linkController.text = '';
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    linkController.dispose();
    tagController.dispose();
    typeController.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostError) {
          Navigator.pop(context);
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is PostCreated) {
          CoreUtils.showSnackBar(context, 'Post created successfully!');
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white, // BackButton 색상을 흰색으로 설정
          ),
          title: const Text(
            '投稿を作成',
            style: TextStyle(color: Colors.white), // AppBar 제목 색상을 흰색으로 설정
          ),
          backgroundColor: Colors.black, // AppBar 배경색을 검정색으로 설정
          actions: [
            BlocBuilder<PostCubit, PostState>(
              builder: (context, state) {
                if (state is PostLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (titleController.text.trim().isNotEmpty &&
                          (contentController.text.trim().isNotEmpty ||
                              linkController.text.trim().isNotEmpty)) {
                        final post = PostModel(
                          postId: '_new.PostId',
                          title: titleController.text,
                          upvotes: [],
                          downvotes: [],
                          commentCount: 0,
                          author: user.fullName,
                          uid: user.uid,
                          type: kPostTypes[typeController.value],
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                          content: contentController.text,
                          link: linkController.text,
                          tags: [kPostTags[tagController.value]],
                        );
                        if (post.type == 'image') {
                          context.read<PostCubit>().createPostWithImage(
                                post: post.copyWith(
                                  content: '',
                                ),
                                image: imageController.value,
                              );
                        } else {
                          context.read<PostCubit>().createPost(post);
                        }
                      }
                    }
                  },
                  child: const Text(
                    '投稿する',
                    style:
                        TextStyle(color: Colors.white), // 완료 버튼 텍스트 색상을 흰색으로 설정
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    AddPostForm(
                      titleController: titleController,
                      contentController: contentController,
                      imageController: imageController,
                      linkController: linkController,
                      tagController: tagController,
                      typeController: typeController,
                      formKey: formKey,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
