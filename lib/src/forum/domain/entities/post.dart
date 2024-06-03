import 'package:equatable/equatable.dart';

class Post extends Equatable {
  const Post({
    required this.postId,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
  });

  Post.empty([DateTime? date])
      : this(
          postId: '_empty.postId',
          title: '_empty.title',
          content: '_empty.content',
          author: '_empty.author',
          createdAt: date ?? DateTime.now(),
          updatedAt: date ?? DateTime.now(),
        );

  final String postId;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object> get props => [postId];

  @override
  String toString() =>
      'Post(postId: $postId, title: $title, content: $content, author: $author, '
      'createdAt: $createdAt, updatedAt: $updatedAt)';
}
