import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  const Comment({
    required this.commentId,
    required this.content,
    required this.postId,
    required this.author,
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    this.profilePic,
  });

  Comment.empty([DateTime? date])
      : this(
          commentId: '_empty.commentId',
          content: '_empty.content',
          postId: '_empty.postId',
          author: '_empty.username',
          uid: '_empty.uid',
          profilePic: '_empty.profilePic',
          createdAt: date ?? DateTime.now(),
          updatedAt: date ?? DateTime.now(),
        );

  final String commentId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String postId;
  final String author;
  final String uid;
  final String? profilePic;

  @override
  List<Object> get props => [commentId];

  @override
  String toString() =>
      'Comment(commentId: $commentId, text: $content, postId: $postId, username: $author, '
      'profilePic: $profilePic, createdAt: $createdAt, updatedAt: $updatedAt) uid: $uid';
}
