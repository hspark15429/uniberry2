import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:uniberry2/core/common/views/loading_view.dart';
import 'package:uniberry2/core/services/injection_container.dart';
import 'package:uniberry2/core/utils/constants.dart';
import 'package:uniberry2/core/utils/core_utils.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/data/models/post_model.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';

import 'package:uniberry2/src/forum/presentation/cubit/post_cubit.dart';
import 'package:uniberry2/src/forum/presentation/widgets/announcement_card.dart';
import 'package:uniberry2/src/forum/presentation/widgets/forum_body_subheader1.dart';
import 'package:uniberry2/src/forum/presentation/widgets/forum_body_subheader2.dart';
import 'package:uniberry2/src/forum/presentation/widgets/post_card.dart';

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
        SliverToBoxAdapter(
          child: BlocProvider(
            create: (context) => sl<PostCubit>(),
            child: const ForumBodySubHeader2(),
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
                    'Please refresh or try again later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black), // 텍스트 색상 변경
                  ),
                ),
              );
            }

            state as PostsSearchedWithPagekey;

            if (state.searchResult.pageKey == 1) {
              _pagingController.refresh();
            }
            _pagingController.appendPage(
                state.searchResult.posts, state.searchResult.nextPageKey);
            return PagedSliverList<int, Post>(
              pagingController: _pagingController,
              // physics: const NeverScrollableScrollPhysics(),
              builderDelegate: PagedChildBuilderDelegate<Post>(
                noItemsFoundIndicatorBuilder: (_) => const Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(color: Colors.black), // 텍스트 색상 변경
                  ),
                ),
                itemBuilder: (_, item, __) => PostCard(post: item),
              ),
            );
          },
        ),
      ],
    );
  }
}
