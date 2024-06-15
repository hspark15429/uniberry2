import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/core/common/views/loading_view.dart';
import 'package:uniberry2/core/utils/core_utils.dart';
import 'package:uniberry2/src/forum/presentation/cubit/post_cubit.dart';

class ForumBody extends StatefulWidget {
  const ForumBody({
    super.key,
  });

  @override
  State<ForumBody> createState() => _ForumBodyState();
}

class _ForumBodyState extends State<ForumBody> {
  void readPosts() {
    context.read<PostCubit>().searchPosts('');
  }

  @override
  void initState() {
    super.initState();
    readPosts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is PostsSearched && state.postIds.isNotEmpty) {
          context.read<PostCubit>().readPosts(state.postIds);
        }
      },
      builder: (context, state) {
        if (state is! PostsRead && state is! PostError) {
          return const LoadingView();
        }
        if ((state is PostsRead && state.posts.isEmpty) || state is PostError) {
          return const Center(
            child: Text(
              'No posts found',
              textAlign: TextAlign.center,
            ),
          );
        }

        state as PostsRead;

        final courses = state.posts
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

        return ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return ListTile(
              title: Text(course.title),
              subtitle: Text(course.content),
              trailing: Text('${course.createdAt}'),
            );
          },
        );
      },
    );
  }
}
