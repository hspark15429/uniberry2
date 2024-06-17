import 'package:flutter/material.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';

class PostDetailsView extends StatefulWidget {
  const PostDetailsView(this.post, {super.key});

  final Post post;

  static const String id = '/post-details';

  @override
  State<PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends State<PostDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
      ),
      body: Center(
        child: Text(widget.post.content!),
      ),
    );
  }
}
