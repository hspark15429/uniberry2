import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  const Comment({
    required this.commentId,
    required this.text,
    required this.postId,
    required this.username,
    required this.profilePic,
    required this.createdAt,
    required this.updatedAt,
  });

  Comment.empty([DateTime? date])
      : this(
          commentId: '_empty.commentId',
          text: '_empty.text',
          postId: '_empty.postId',
          username: '_empty.username',
          profilePic: '_empty.profilePic',
          createdAt: date ?? DateTime.now(),
          updatedAt: date ?? DateTime.now(),
        );

  final String commentId;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String postId;
  final String username;
  final String profilePic;

  @override
  List<Object> get props => [commentId];

  @override
  String toString() =>
      'Comment(commentId: $commentId, text: $text, postId: $postId, username: $username, '
      'profilePic: $profilePic, createdAt: $createdAt, updatedAt: $updatedAt)';
}
