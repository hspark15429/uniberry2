import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uniberry2/core/common/providers/tab_navigator.dart';
import 'package:uniberry2/core/providers/user_provider.dart';
import 'package:uniberry2/core/utils/constants.dart';
import 'package:uniberry2/core/utils/core_utils.dart';
import 'package:uniberry2/src/auth/domain/entities/user.dart';
import 'package:uniberry2/src/forum/data/models/post_model.dart';
import 'package:uniberry2/src/forum/presentation/cubit/post_cubit.dart';
import 'package:uniberry2/src/forum/presentation/widgets/add_post_form.dart';

class AddPostView extends StatefulWidget {
  const AddPostView({super.key});

  static const id = '/post/create';

  @override
  State<AddPostView> createState() => _AddPostViewState();
}

class _AddPostViewState extends State<AddPostView> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final tagController = ValueNotifier<int>(0);
  final formKey = GlobalKey<FormState>();

  late LocalUser user;

  @override
  void initState() {
    user = context.read<UserProvider>().user!;
    titleController.text = '';
    contentController.text = '';
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
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
            'Add Post',
            style: TextStyle(color: Colors.white), // AppBar 제목 색상을 흰색으로 설정
          ),
          backgroundColor: Colors.black, // AppBar 배경색을 검정색으로 설정
          actions: [
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (titleController.text.trim().isNotEmpty &&
                      contentController.text.trim().isNotEmpty) {
                    context.read<PostCubit>().createPost(
                          PostModel(
                            postId: '_new.PostId',
                            title: titleController.text,
                            upvotes: [],
                            downvotes: [],
                            commentCount: 0,
                            author: user.fullName,
                            uid: user.uid,
                            type: 'text',
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                            content: contentController.text,
                            tags: [kPostTags[tagController.value]],
                          ),
                        );
                  }
                }
              },
              child: const Text(
                '완료',
                style: TextStyle(color: Colors.white), // 완료 버튼 텍스트 색상을 흰색으로 설정
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  AddPostForm(
                    titleController: titleController,
                    contentController: contentController,
                    tagController: tagController,
                    formKey: formKey,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}