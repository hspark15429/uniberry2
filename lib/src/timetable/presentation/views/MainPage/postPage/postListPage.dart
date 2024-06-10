import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/postPage/dummy_data.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/postPage/postDetail.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/postPage/postWritePage.dart';

class Postlistpage extends StatefulWidget {
  const Postlistpage({required this.boardName, super.key});
  final String boardName;

  @override
  _PostlistpageState createState() => _PostlistpageState();
}

class _PostlistpageState extends State<Postlistpage> {
  List<Post> boardPosts = [];

  @override
  void initState() {
    super.initState();
    boardPosts = dummyPosts.where((post) => post.category == widget.boardName).toList();
  }

  @override
  Widget build(BuildContext context) {
    // 실제 사용자 정보 필요
    const currentUser = '현재 사용자'; // 여기에 실제 사용자 정보를 삽입

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.boardName}  ',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
builder: (context) => const Postwritepage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: boardPosts.length,
        itemBuilder: (context, index) {
          final post = boardPosts[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostDetailPage(post: post)),
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
                  Text(
                    post.title,
style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
'작성일 ${post.datePosted} · 조회수 ${post.viewCount}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  if (post.imageUrls.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(File(post.imageUrls.first), fit: BoxFit.cover),
                      ),
                    ),
                  // 작성자 정보와 삭제 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '작성자: ${post.author}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      if (post.author == currentUser) 
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {}, // 삭제 함수 자리
                        ),
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
