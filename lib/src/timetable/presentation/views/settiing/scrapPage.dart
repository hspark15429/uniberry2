import 'package:flutter/material.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Anonymous_thread/dummy_data.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Anonymous_thread/post_detail.dart';
import 'package:uniberry2/src/timetable/presentation/views/settiing/scrapDataPsge.dart';


class BookmarkManagerPage extends StatelessWidget {
  // 북마크된 게시물 목록을 가져오는 함수
  List<Post> getBookmarkedPosts() {
  final bookmarkedTitles = BookmarkService().getBookmarkedPosts(); // 북마크된 게시물의 title 목록
  return dummyPosts.where((post) => bookmarkedTitles.contains(post.title)).toList();
}


    

  @override
  Widget build(BuildContext context) {
    final bookmarkedPosts = getBookmarkedPosts();

    return Scaffold(
      appBar: AppBar(
        title: Text('북마크 관리'),
      ),
      body: ListView.builder(
        itemCount: bookmarkedPosts.length,
        itemBuilder: (context, index) {
          final post = bookmarkedPosts[index];
          return ListTile(
            title: Text(post.title),
            subtitle: Text(post.content),
            onTap: () {
              // 상세 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostDetailPage(post: post)),
              );
            },
          );
        },
      ),
    );
  }
}