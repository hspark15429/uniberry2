import 'package:cloud_firestore/cloud_firestore.dart';
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

  PostModel.empty([DateTime? date])
      : this(
          postId: '_empty.postId',
          title: '_empty.title',
          content: '_empty.content',
          author: '_empty.author',
          createdAt: date ?? DateTime.now(),
          updatedAt: date ?? DateTime.now(),
        );

  PostModel.fromMap(DataMap map)
      : this(
          postId: map['postId'] as String,
          title: map['title'] as String,
          content: map['content'] as String,
          author: map['author'] as String,
          createdAt: (map['createdAt'] as Timestamp).toDate(),
          updatedAt: (map['updatedAt'] as Timestamp).toDate(),
        );

  DataMap toMap() {
    return {
      'postId': postId,
      'title': title,
      'content': content,
      'author': author,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  PostModel copyWith({
    String? postId,
    String? title,
    String? content,
    String? author,
    DateTime? createdAt,
    DateTime? updatedAt,
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
