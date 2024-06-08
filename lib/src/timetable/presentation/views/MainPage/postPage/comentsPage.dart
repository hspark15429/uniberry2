import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uniberry2/src/timetable/presentation/views/MainPage/postPage/dummy_data.dart';

class CommentsPage extends StatefulWidget {
  final List<Comment> comments;

  const CommentsPage({Key? key, required this.comments}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Comment> _comments = [];
  Map<int, bool> _showReplies = {};

  @override
  void initState() {
    super.initState();
    _comments = widget.comments;
    timeago.setLocaleMessages('ko', timeago.KoMessages()); // 한글 시간 표시
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
'댓글',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(_focusNode);
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  final showReplies = _showReplies[index] ?? false;
                  final commentTime = timeago.format(DateTime.parse(comment.datePosted), locale: 'ko');

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            comment.content,
                            style: const TextStyle(fontSize: 16.0, color: Colors.black),
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
                                        onPressed: () {}, // 좋아요 함수 
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
                                  onTap: () {}, // 댓글 펼치기/보여주기
                                  child: Text(
                                    showReplies
                                        ? "댓글 숨기기"
                                        : "${comment.replies.length}개의 댓글 더보기",
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.comment, size: 20, color: Colors.black),
                            onPressed: () {}, // 대댓글 함수
                          ),
                        ),
                        if (showReplies)
                          ...comment.replies.asMap().entries.map((entry) {
                            final reply = entry.value;
                            final replyIndex = entry.key;
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
                                            onPressed: () {}, // 좋아요 함수
                                          ),
                                          Text(
                                            "${reply.likesCount}",
                                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.comment, size: 16, color: Colors.black),
                                            onPressed: () {}, // 대댓글 함수
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
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildCommentInputField(),
            ),
          ],
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
              focusNode: _focusNode,
              controller: _commentController,
              decoration: const InputDecoration(
hintText: "댓글달기",
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
            onPressed: () {}, // 댓글 추가 함수 
          ),
        ],
      ),
    );
  }

  Widget _buildReplyInputField(int index) {
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
hintText: "보내기",
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
            onPressed: () {}, // 답글 추가 함수 
          ),
        ],
      ),
    );
  }
}
