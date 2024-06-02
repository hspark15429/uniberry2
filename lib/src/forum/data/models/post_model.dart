import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.postId,
    required super.title,
    required super.content,
    required super.author,
    required super.createdAt,
    required super.updatedAt,
  });

  const PostModel.empty()
      : this(
          postId: '',
          title: '',
          content: '',
          author: '',
          createdAt: '',
          updatedAt: '',
        );
  PostModel.fromMap(DataMap map)
      : this(
          postId: map['postId'] as String,
          title: map['title'] as String,
          content: map['content'] as String,
          author: map['author'] as String,
          createdAt: map['createdAt'] as String,
          updatedAt: map['updatedAt'] as String,
        );
  DataMap toMap() {
    return {
      'postId': postId,
      'title': title,
      'content': content,
      'author': author,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  PostModel copyWith({
    String? postId,
    String? title,
    String? content,
    String? author,
    String? createdAt,
    String? updatedAt,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
