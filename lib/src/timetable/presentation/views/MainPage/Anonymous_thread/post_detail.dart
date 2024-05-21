import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Anonymous_thread/coments_page.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Anonymous_thread/dummy_data.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool hasLiked = false;
  int likesCount = 0;

  @override
  void initState() {
    super.initState();
    likesCount = widget.post.likesCount; // 초기 좋아요 수 설정
  }

  void _toggleLike() {
    if (!hasLiked) {
      setState(() {
        hasLiked = true;
        likesCount++;
        widget.post.likesCount++; // 실제 데이터에서도 증가시키기 위해 설정
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.post.title, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              Share.share('Check out this post: ${widget.post.title}\n${widget.post.content}');
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("북마크에 저장되었습니다."),
                  duration: Duration(seconds: 2),
                ),
              );
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
              Text("#${widget.post.category}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent)),
              const SizedBox(height: 8),
              Text(widget.post.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 8),
              Text(widget.post.content, style: TextStyle(color: Colors.grey[800])),
              if (widget.post.imageUrls.isNotEmpty)
                Container(
                  height: 300,
                  margin: const EdgeInsets.only(top: 16),
                  child: PageView.builder(
                    itemCount: widget.post.imageUrls.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ImageViewerPage(imageUrls: widget.post.imageUrls, initialIndex: index),
                          ),
                        ),
                        child: Image.network(widget.post.imageUrls[index], fit: BoxFit.contain),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              Text("작성자: ${widget.post.author}", style: const TextStyle(color: Colors.black)),
              const SizedBox(height: 4),
              Text("작성일: ${widget.post.datePosted}", style: const TextStyle(color: Colors.black)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      hasLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                      size: 20,
                      color: Colors.black,
                    ),
                    onPressed: _toggleLike,
                  ),
                  Text("$likesCount", style: const TextStyle(color: Colors.black)),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.comment, size: 20, color: Colors.black),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => CommentsPage(comments: widget.post.comments),
                      );
                    },
                  ),
                  Text("${widget.post.commentCount}", style: const TextStyle(color: Colors.black)),
                ],
              ),
              const SizedBox(height: 16),
              ...widget.post.comments.map((comment) => Container(
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
                    child: ListTile(
                      title: Text(comment.content, style: const TextStyle(color: Colors.black)),
                      subtitle: Text("작성일: ${comment.datePosted}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.thumb_up_alt_outlined, size: 20, color: Colors.black),
                            onPressed: () {
                              // 댓글에 대한 좋아요 기능 구현
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.comment, size: 20, color: Colors.black),
                            onPressed: () {
                              // 답글 기능 구현
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageViewerPage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageViewerPage({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  _ImageViewerPageState createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("${currentIndex + 1}/${widget.imageUrls.length}", style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PageView.builder(
        itemCount: widget.imageUrls.length,
        controller: PageController(initialPage: currentIndex),
        onPageChanged: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Hero(
            tag: 'imageHero',
            child: Image.network(widget.imageUrls[index], fit: BoxFit.contain),
          );
        },
      ),
    );
  }
}
