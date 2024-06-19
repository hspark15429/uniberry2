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
  int _currentPage = 0;

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
          final posts = state.searchResult.posts.take(5).toList();
          return Center(
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Announcements',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 190, // 카드 크기를 키우기 위해 높이를 조정
                      child: PageView.builder(
                        itemCount: posts.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return AnnouncementItem(
                            imagePath: post.content!,
                            title: post.title,
                            link: post.link,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        posts.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.black
                                : Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
