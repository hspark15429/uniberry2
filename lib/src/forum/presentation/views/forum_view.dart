import 'package:flutter/material.dart';
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
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
