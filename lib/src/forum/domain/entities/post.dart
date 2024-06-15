import 'package:equatable/equatable.dart';

class Post extends Equatable {
  const Post({
    required this.postId,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
  });

  Post.empty([DateTime? date])
      : this(
          postId: '_empty.postId',
          title: '_empty.title',
          content: '_empty.content',
          author: '_empty.author',
          createdAt: date ?? DateTime.now(),
          updatedAt: date ?? DateTime.now(),
          tags: const ['_empty.tag'],
        );

  final String postId;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;

  @override
  List<Object> get props => [postId];

  @override
  String toString() =>
      'Post(postId: $postId, title: $title, content: $content, author: $author, '
      'tags: $tags createdAt: $createdAt, updatedAt: $updatedAt)';
}
