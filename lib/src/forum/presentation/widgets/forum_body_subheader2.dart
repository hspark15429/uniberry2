import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry/src/forum/presentation/cubit/post_cubit.dart';
import 'package:uniberry/src/forum/presentation/widgets/announcement_card.dart';

class ForumBodySubHeader2 extends StatefulWidget {
  const ForumBodySubHeader2({
    super.key,
  });

  @override
  State<ForumBodySubHeader2> createState() => _ForumBodySubHeaderState();
}

class _ForumBodySubHeaderState extends State<ForumBodySubHeader2> {
  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().searchPostsWithPageKey(
      query: '',
      pageKey: 1,
      tags: ['public'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostsSearchedWithPagekey) {
          return SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: state.searchResult.posts
                  .map((post) => AnnouncementItem(
                        imagePath: post.content!,
                        title: post.title,
                        link: post.link,
                      ))
                  .toList(),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
