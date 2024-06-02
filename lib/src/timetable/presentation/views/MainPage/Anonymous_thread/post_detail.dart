import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
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
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    likesCount = widget.post.likesCount; // 초기 좋아요 수 설정
    timeago.setLocaleMessages('ko', timeago.KoMessages()); // 한글 시간 표시
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

  void _likeComment(int commentIndex) {
    setState(() {
      widget.post.comments[commentIndex].likesCount++;
    });
  }

  void _likeReply(int commentIndex, int replyIndex) {
    setState(() {
      widget.post.comments[commentIndex].replies[replyIndex].likesCount++;
    });
  }

  void _addComment(String content) {
    final newComment = Comment(
      content: content,
      datePosted: DateTime.now().toString(),
      likesCount: 0,
    );
    setState(() {
      widget.post.comments.add(newComment);
    });
  }

  void _addReply(int commentIndex, String replyContent) {
    final newReply = Comment(
      content: replyContent,
      datePosted: DateTime.now().toString(),
      likesCount: 0,
    );
    setState(() {
      widget.post.comments[commentIndex].replies.add(newReply);
    });
  }

  void _toggleReplies(int index) {
    setState(() {
      widget.post.comments[index].isExpanded = !widget.post.comments[index].isExpanded;
    });
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
                        builder: (context) => _buildCommentInputField(),
                      );
                    },
                  ),
                  Text("${widget.post.comments.length}", style: const TextStyle(color: Colors.black)),
                ],
              ),
              const SizedBox(height: 16),
              ...widget.post.comments.asMap().entries.map((entry) {
                final comment = entry.value;
                final commentIndex = entry.key;
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
                                      onPressed: () => _likeComment(commentIndex),
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
                            if (comment.replies.isNotEmpty)
                              GestureDetector(
                                onTap: () => _toggleReplies(commentIndex),
                                child: Text(
                                  comment.isExpanded ? "댓글 숨기기" : "${comment.replies.length}개의 댓글 더보기",
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.comment, size: 20, color: Colors.black),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => _buildReplyInputField(commentIndex),
                            );
                          },
                        ),
                      ),
                      if (comment.isExpanded)
                        ...comment.replies.asMap().entries.map((replyEntry) {
                          final reply = replyEntry.value;
                          final replyIndex = replyEntry.key;
                          final replyTime = timeago.format(DateTime.parse(reply.datePosted), locale: 'ko');

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(reply.content, style: const TextStyle(color: Colors.black)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.thumb_up, size: 16, color: Colors.black),
                                          onPressed: () => _likeReply(commentIndex, replyIndex),
                                        ),
                                        Text(
                                          "${reply.likesCount}",
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.comment, size: 16, color: Colors.black),
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) => _buildReplyInputField(commentIndex),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      replyTime,
                                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
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

  Widget _buildCommentInputField() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: "댓글을 입력하세요...",
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 14.0, color: Colors.black),
              minLines: 1,
              maxLines: 5,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.black),
            onPressed: () {
              _addComment(_commentController.text);
              _commentController.clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReplyInputField(int commentIndex) {
    final TextEditingController _replyController = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _replyController,
              decoration: const InputDecoration(
                hintText: "답글을 입력하세요...",
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 14.0, color: Colors.black),
              minLines: 1,
              maxLines: 5,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.black),
            onPressed: () {
              _addReply(commentIndex, _replyController.text);
              _replyController.clear();
              Navigator.pop(context);
            },
          ),
        ],
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