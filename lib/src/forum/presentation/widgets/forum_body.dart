import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:uniberry2/core/common/views/loading_view.dart';
import 'package:uniberry2/core/utils/constants.dart';
import 'package:uniberry2/core/utils/core_utils.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/data/models/post_model.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';

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

  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 0);

  void searchPostsWithPageKey({required String query, required int pageKey}) {
    context
        .read<PostCubit>()
        .searchPostsWithPageKey(query: query, pageKey: pageKey);
  }

  @override
  void initState() {
    super.initState();
    tags = kPostTags;
    searchPostsWithPageKey(query: '', pageKey: 0);
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
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is! PostsSearchedWithPagekey && state is! PostError) {
          return const LoadingView();
        }
        if ((state is PostsSearchedWithPagekey &&
                state.searchResult.posts.isEmpty) ||
            state is PostError) {
          return const Center(
            child: Text(
              'No posts found',
              textAlign: TextAlign.center,
            ),
          );
        }

        state as PostsSearchedWithPagekey;

        if (state.searchResult.pageKey == 1) {
          _pagingController.refresh();
        }
        _pagingController.appendPage(
            state.searchResult.posts, state.searchResult.nextPageKey);

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
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
            ),
            SliverToBoxAdapter(
              child: SizedBox(
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
            ),
            PagedSliverList<int, Post>(
              pagingController: _pagingController,
              // physics: const NeverScrollableScrollPhysics(),
              builderDelegate: PagedChildBuilderDelegate<Post>(
                noItemsFoundIndicatorBuilder: (_) => const Center(
                  child: Text('No results found'),
                ),
                itemBuilder: (_, item, __) => Container(
                  color: Colors.white,
                  height: 80,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      SizedBox(width: 50, child: Text(item.title)),
                      const SizedBox(width: 20),
                      SizedBox(width: 30, child: Text(item.content)),
                      const SizedBox(width: 20),
                      Expanded(child: Text(item.author))
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
