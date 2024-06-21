import 'package:equatable/equatable.dart';

class Post extends Equatable {
  const Post({
    required this.postId,
    required this.title,
    required this.upvotes,
    required this.downvotes,
    required this.commentCount,
    required this.author,
    required this.uid,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.content,
    this.link,
    this.tags = const [],
  });

  Post.empty([DateTime? date])
      : this(
          postId: '_empty.postId',
          title: '_empty.title',
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          author: '_empty.author',
          uid: '_empty.uid',
          type: 'image',
          createdAt: date ?? DateTime.now(),
          updatedAt: date ?? DateTime.now(),
        );

  final String postId;
  final String title;
  final String? content;
  final String? link;
  final List<String>? tags;
  final List<String> upvotes;
  final List<String> downvotes;
  final int commentCount;
  final String author;
  final String uid;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object> get props => [postId];

  @override
  String toString() =>
      'Post{postId: $postId, title: $title, author: $author, createdAt: '
      '$createdAt updatedAt: $updatedAt, type: $type, tags: $tags, '
      'upvotes: $upvotes, downvotes: $downvotes content: $content, '
      'link: $link, uid: $uid, commentCount: $commentCount}';
}
