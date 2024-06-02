import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        body: BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostError) {
          return CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is CreatingPost) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostCreated) {
          return const Center(child: Text('Post Created'));
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TextButton(
                onPressed: () {
                  context.read<PostCubit>().createPost(
                        'title',
                        'content',
                        'author',
                        'createdAt',
                        'updatedAt',
                      );
                },
                child: const Text(
                  'Create a Post',
                ),
              ),
            ),
          ],
        );
      },
    ));
  }
}
