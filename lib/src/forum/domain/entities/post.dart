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

  const Post.empty()
      : postId = '',
        title = '',
        content = '',
        author = '',
        createdAt = '',
        updatedAt = '';

  final String postId;
  final String title;
  final String content;
  final String author;
  final String createdAt;
  final String updatedAt;

  @override
  List<Object> get props => [postId];

  @override
  String toString() =>
      'Post(postId: $postId, title: $title, content: $content, author: $author, '
      'createdAt: $createdAt, updatedAt: $updatedAt)';
}
