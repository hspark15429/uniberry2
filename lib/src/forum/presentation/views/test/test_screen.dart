import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/core/enums/update_post_enum.dart';
import 'package:uniberry2/core/utils/core_utils.dart';
import 'package:uniberry2/src/forum/presentation/cubit/post_cubit.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  static const String routeName = '/forum';

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/forum');
            },
            icon: const Icon(Icons.refresh),
            iconSize: 30,
          ),
        ],
      ),
      body: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          if (state is PostError) {
            return CoreUtils.showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostCreated) {
            return const Center(child: Text('Post Created'));
          } else if (state is PostRead) {
            return Center(child: Text(state.post.toString()));
          } else if (state is PostUpdated) {
            return const Center(child: Text('Post Updated'));
          } else if (state is PostDeleted) {
            return const Center(child: Text('Post Deleted'));
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<PostCubit>().createPost(
                          title: 'title',
                          content: 'content',
                          author: 'author',
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        );
                  },
                  child: const Text(
                    'Create a Post',
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<PostCubit>().readPost('ninwJiBBYaTKaVyRf9VL');
                  },
                  child: const Text(
                    'Read post #1',
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<PostCubit>().updatePost(
                          postId: 'ninwJiBBYaTKaVyRf9VL',
                          action: UpdatePostAction.title,
                          postData: 'Updated Title 2222',
                        );
                  },
                  child: const Text(
                    'Update post #1',
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<PostCubit>()
                        .deletePost('ninwJiBBYaTKaVyRf9VL');
                  },
                  child: const Text(
                    'delete post #1',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
