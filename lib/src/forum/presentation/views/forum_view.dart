import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniberry/core/common/providers/tab_navigator.dart';
import 'package:uniberry/src/forum/presentation/views/add_post_view.dart';
import 'package:uniberry/src/forum/presentation/views/add_course_review_view.dart'; // 새로 추가한 파일 import
import 'package:uniberry/src/forum/presentation/widgets/forum_app_bar.dart';
import 'package:uniberry/src/forum/presentation/widgets/forum_body.dart';

class ForumView extends StatefulWidget {
  const ForumView({Key? key}) : super(key: key);

  @override
  State<ForumView> createState() => _ForumViewState();
}

class _ForumViewState extends State<ForumView> {
  Key _forumBodyKey = UniqueKey();

  void _refreshContent() {
    setState(() {
      _forumBodyKey = UniqueKey();
    });
  }

  Future<void> _navigateToAddPost(BuildContext context) async {
    await Navigator.pushNamed(context, AddPostView.id);
    // 화면이 되돌아올 때마다 새로고침
    _refreshContent();
  }

  Future<void> _navigateToAddCourseReview(BuildContext context) async {
    await Navigator.pushNamed(
      context,
      AddCourseReviewView.id,
      arguments: {'reviewId': 'some_review_id'}, // 실제 reviewId를 전달
    );
    _refreshContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ForumAppBar(
        onRefresh: _refreshContent,
      ),
      body: ForumBody(key: _forumBodyKey),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.article_outlined),
                    title: const Text('投稿を作成'),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToAddPost(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.rate_review_outlined),
                    title: const Text('授業レビューを作成'),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToAddCourseReview(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
