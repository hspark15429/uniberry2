import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniberry2/core/common/providers/tab_navigator.dart';
import 'package:uniberry2/src/forum/presentation/views/add_post_view.dart';
import 'package:uniberry2/src/forum/presentation/widgets/forum_app_bar.dart';
import 'package:uniberry2/src/forum/presentation/widgets/forum_body.dart';

class ForumView extends StatefulWidget {
  const ForumView({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ForumAppBar(
        onRefresh: _refreshContent,
      ),
      body: ForumBody(key: _forumBodyKey),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddPostView.id);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.black, //
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      backgroundColor: Colors.white, // 전체 배경을 흰색으로 설정
    );
  }
}
