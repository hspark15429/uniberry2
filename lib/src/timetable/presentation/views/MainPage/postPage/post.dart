import 'package:flutter/material.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/postPage/dummy_data.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/postPage/postDetail.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/postPage/postWritePage.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText({
    required this.text,
    super.key,
    this.maxLines = 2,
  });
  final String text;
  final int maxLines;

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    var textPainter = TextPainter(
      text: TextSpan(
          text: widget.text, style: DefaultTextStyle.of(context).style),
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);
    final isOverflow = textPainter.didExceedMaxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: isExpanded ? null : widget.maxLines,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (isOverflow)
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? '閉じる' : '開く',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
      ],
    );
  }
}

class PostPage extends StatefulWidget {
  const PostPage({required this.currentBoard, super.key});
  final String currentBoard;

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<Post> filteredPosts = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredPosts = dummyPosts
        .where((post) =>
            post.boardType.toString().split('.').last == widget.currentBoard)
        .toList();
    filteredPosts
        .sort((a, b) => b.datePosted.compareTo(a.datePosted)); // 최신순 정렬
  }

  List<Post> _filterPosts(String query) {
    return dummyPosts.where((post) {
      return post.boardType.toString().split('.').last == widget.currentBoard &&
          (post.title.contains(query) || post.content.contains(query));
    }).toList()
      ..sort((a, b) => b.datePosted.compareTo(a.datePosted)); // 최신순 정렬
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '#${boardTypeToString(BoardType.values.firstWhere((type) => type.toString().split('.').last == widget.currentBoard))}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PostSearchDelegate(
                  currentBoard: widget.currentBoard,
                  filterPosts: _filterPosts,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.create, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Postwritepage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          final post = filteredPosts[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostDetailPage(post: post)),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (post.imageUrls.isNotEmpty)
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(right: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(post.imageUrls.first,
                                fit: BoxFit.cover, width: 100, height: 100),
                          ),
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('#${post.category}',
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(post.title,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                                '作成日 ${post.datePosted} · 閲覧数 ${post.viewCount}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                            const SizedBox(height: 8),
                            ExpandableText(text: post.content),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (post.imageUrls.isNotEmpty) const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.thumb_up, color: Colors.grey, size: 20),
                      const SizedBox(width: 4),
                      Text('${post.likesCount}',
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 16),
                      const Icon(Icons.comment, color: Colors.grey, size: 20),
                      const SizedBox(width: 4),
                      Text('${post.commentCount}',
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PostSearchDelegate extends SearchDelegate {
  PostSearchDelegate({required this.currentBoard, required this.filterPosts});
  final String currentBoard;
  final List<Post> Function(String) filterPosts;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredPosts = filterPosts(query);
    return _buildResultsList(filteredPosts);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredPosts = filterPosts(query);
    return _buildResultsList(filteredPosts);
  }

  Widget _buildResultsList(List<Post> filteredPosts) {
    return ListView.builder(
      itemCount: filteredPosts.length,
      itemBuilder: (context, index) {
        final post = filteredPosts[index];
        return ListTile(
          title: Text(post.title),
          subtitle: Text('作成日 ${post.datePosted}\n${post.content}',
              maxLines: 2, overflow: TextOverflow.ellipsis),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetailPage(post: post)),
            );
          },
        );
      },
    );
  }
}
