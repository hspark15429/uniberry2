import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/core/common/views/loading_view.dart';
import 'package:uniberry2/core/utils/constants.dart';
import 'package:uniberry2/core/utils/core_utils.dart';
import 'package:uniberry2/src/forum/presentation/cubit/post_cubit.dart';
import 'package:uniberry2/src/forum/presentation/widgets/announcement_card.dart';

class ForumBody extends StatefulWidget {
  const ForumBody({
    super.key,
  });

  @override
  State<ForumBody> createState() => _ForumBodyState();
}

class _ForumBodyState extends State<ForumBody> {
  late List<String> tags;
  int? selectedTagIndex;

  void readPosts() {
    context.read<PostCubit>().searchPosts('');
  }

  @override
  void initState() {
    super.initState();
    tags = kPostTags;
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

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    AnnouncementItem('assets/images/start_img.png', 'Hospital'),
                    AnnouncementItem('assets/images/start_img.png', 'Baseball'),
                    AnnouncementItem(
                        'assets/images/start_img.png', 'Basketball'),
                    AnnouncementItem('assets/images/start_img.png', 'Football'),
                    AnnouncementItem(
                        'assets/images/start_img.png', 'Horse Riding'),
                    AnnouncementItem(
                        'assets/images/start_img.png', 'Tennis Club'),
                    AnnouncementItem(
                        'assets/images/start_img.png', 'Book Club'),
                    AnnouncementItem('assets/images/start_img.png', 'Cycling'),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tags.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(tags[index]),
                        selected: selectedTagIndex == index,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedTagIndex = selected ? index : null;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return ListTile(
                    title: Text(course.title),
                    subtitle: Text(course.content),
                    trailing: Text('${course.createdAt}'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
