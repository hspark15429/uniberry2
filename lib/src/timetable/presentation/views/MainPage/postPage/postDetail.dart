import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uniberry2/src/timetable/presentation/views/MainPage/postPage/dummy_data.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(post.title, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              Share.share(post.content);
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {
              // 북마크 함수
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
padding: const EdgeInsets.all(16.0),
          child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
            children: [
Text("#${post.category}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent,)),
              const SizedBox(height: 8),
Text(post.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,)),
              const SizedBox(height: 8),
              Text(post.content, style: TextStyle(color: Colors.grey[800])),
              if (post.imageUrls.isNotEmpty)
                Container(
                  height: 300,
                  margin: const EdgeInsets.only(top: 16),
                  child: PageView.builder(
                    itemCount: post.imageUrls.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ImageViewerPage(
                              imageUrls: post.imageUrls,
                              initialIndex: index,
                            ),
                          ),
                        ),
                        child: Image.network(post.imageUrls[index], fit: BoxFit.contain),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              Text("작성자: ${post.author}", style: const TextStyle(color: Colors.black)),
              const SizedBox(height: 4),
              Text("작성일: ${post.datePosted}", style: const TextStyle(color: Colors.black)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up_alt_outlined, size: 20, color: Colors.black),
                    onPressed: () {
                      // 좋아요 함수
                    },
                  ),
                  Text("${post.likesCount}", style: const TextStyle(color: Colors.black)),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.comment, size: 20, color: Colors.black),
                    onPressed: () {
                      // 댓글 함수
                    },
                  ),
                  Text("${post.comments.length}", style: const TextStyle(color: Colors.black)),
                ],
              ),
              const SizedBox(height: 16),
              ...post.comments.asMap().entries.map((entry) {
                final comment = entry.value;
                final commentTime = timeago.format(DateTime.parse(comment.datePosted), locale: 'ko');

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(16.0),
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
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          comment.content,
                          style: const TextStyle(color: Colors.black),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.thumb_up, size: 20, color: Colors.black),
                                      onPressed: () {
                                        // 좋아요 함수
                                      },
                                    ),
                                    Text(
                                      "${comment.likesCount}",
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Text(
                                  commentTime,
                                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.comment, size: 20, color: Colors.black),
                          onPressed: () {
                            //대댓글 함수 
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageViewerPage extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageViewerPage({
    Key? key,
    required this.imageUrls,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("${initialIndex + 1}/${imageUrls.length}", style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PageView.builder(
        itemCount: imageUrls.length,
        controller: PageController(initialPage: initialIndex),
        onPageChanged: (int index) {},
        itemBuilder: (context, index) {
          return Hero(
            tag: 'imageHero',
            child: Image.network(imageUrls[index], fit: BoxFit.contain),
          );
        },
      ),
    );
  }
}
