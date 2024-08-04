import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:uniberry/core/common/views/loading_view.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/services/injection_container.dart';
import 'package:uniberry/core/utils/constants.dart';
import 'package:uniberry/core/utils/core_utils.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/auth/domain/entities/user.dart';
import 'package:uniberry/src/forum/data/models/post_model.dart';
import 'package:uniberry/src/forum/domain/entities/post.dart';
import 'package:uniberry/src/forum/presentation/cubit/post_cubit.dart';
import 'package:uniberry/src/forum/presentation/widgets/announcement_card.dart';
import 'package:uniberry/src/forum/presentation/widgets/forum_body_subheader1.dart';
import 'package:uniberry/src/forum/presentation/widgets/forum_body_subheader2.dart';
import 'package:uniberry/src/forum/presentation/widgets/post_card.dart';
import 'package:uniberry/src/forum/presentation/views/course_review_view.dart'; // Import CourseReviewView

class ForumBody extends StatefulWidget {
  const ForumBody({
    super.key,
  });

  @override
  State<ForumBody> createState() => _ForumBodyState();
}

class _ForumBodyState extends State<ForumBody> {
  late LocalUser user;
  late List<String> tags;
  int? selectedTagIndex;

  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 1);

  void searchPostsWithPageKey({required String query, required int pageKey}) {
    context.read<PostCubit>().searchPostsWithPageKey(
          query: query,
          pageKey: pageKey,
          tags: selectedTagIndex != null ? [tags[selectedTagIndex!]] : [],
        );
  }

  @override
  void initState() {
    super.initState();
    user = context.read<UserProvider>().user!;
    tags = kPostTags;
    searchPostsWithPageKey(query: '', pageKey: 1);
    context.read<PostCubit>().emit(PostInitial()); // hotfix, remove later
    _pagingController.addPageRequestListener((pageKey) {
      searchPostsWithPageKey(query: '', pageKey: pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: BlocProvider(
            create: (context) => sl<PostCubit>(),
            child: const ForumBodySubHeader1(),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.yellow, size: 38),
                SizedBox(width: 8),
                Text(
                  '注目すべき情報',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: BlocProvider(
            create: (context) => sl<PostCubit>(),
            child: const ForumBodySubHeader2(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.diversity_3, color: Colors.black, size: 38),
                    SizedBox(width: 8),
                    Text(
                      '学内掲示板',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CourseReviewView()),
                    );
                  },
                  icon: const Icon(Icons.rate_review_outlined),
                  label: const Text('授業レビュー'),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tags.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FilterChip(
                    label: Text(
                      tags[index],
                      style: TextStyle(
                        color: selectedTagIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: selectedTagIndex == index,
                    selectedColor: Colors.black,
                    backgroundColor: Colors.white,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedTagIndex = selected ? index : null;
                        searchPostsWithPageKey(query: '', pageKey: 1);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ),
        BlocConsumer<PostCubit, PostState>(
          listener: (context, state) {
            if (state is PostError) {
              CoreUtils.showSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is! PostsSearchedWithPagekey && state is! PostError) {
              return const SliverToBoxAdapter(child: LoadingView());
            }
            if ((state is PostsSearchedWithPagekey &&
                    state.searchResult.posts.isEmpty) ||
                state is PostError) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    '投稿がありません。',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              );
            }

            state as PostsSearchedWithPagekey;

            // filter blocked posts
            final filteredPosts = state.searchResult.posts.where((post) {
              return !user.blockedUids.contains(post.uid);
            }).toList();

            if (state.searchResult.pageKey == 1) {
              _pagingController.refresh();
            }
            _pagingController.appendPage(
              filteredPosts,
              state.searchResult.nextPageKey,
            );
            return PagedSliverList<int, Post>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Post>(
                noItemsFoundIndicatorBuilder: (_) => const Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                itemBuilder: (_, item, __) {
                  return PostCard(post: item);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
