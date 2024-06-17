import 'package:flutter/material.dart';
import 'package:uniberry2/src/comment/domain/entities/comment.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    required this.comment,
    super.key,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(comment.content),
        trailing: Text(comment.author),
      ),
    );
  }
}
