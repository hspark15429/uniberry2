import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/comment/domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.commentId,
    required super.content,
    required super.postId,
    required super.author,
    required super.uid,
    required super.createdAt,
    required super.updatedAt,
    super.profilePic,
  });

  CommentModel.empty([DateTime? date])
      : this(
          commentId: '_empty.commentId',
          content: '_empty.content',
          postId: '_empty.postId',
          author: '_empty.author',
          uid: '_empty.uid',
          profilePic: '_empty.profilePic',
          createdAt: date ?? DateTime.now(),
          updatedAt: date ?? DateTime.now(),
        );

  CommentModel.fromMap(DataMap map)
      : this(
          commentId: map['commentId'] as String,
          content: map['content'] as String,
          postId: map['postId'] as String,
          author: map['author'] as String,
          uid: map['uid'] as String,
          createdAt: (map['createdAt'] as Timestamp).toDate(),
          updatedAt: (map['updatedAt'] as Timestamp).toDate(),
          profilePic: map['profilePic'] as String?,
        );

  CommentModel.fromJson(DataMap json)
      : this(
          commentId: json['commentId'] as String,
          content: json['content'] as String,
          postId: json['postId'] as String,
          author: json['author'] as String,
          uid: json['uid'] as String,
          createdAt: (json['createdAt'] as Timestamp).toDate(),
          updatedAt: (json['updatedAt'] as Timestamp).toDate(),
          profilePic: json['profilePic'] as String?,
        );

  DataMap toMap() {
    return {
      'commentId': commentId,
      'content': content,
      'postId': postId,
      'author': author,
      'uid': uid,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'profilePic': profilePic,
    };
  }

  CommentModel copyWith({
    String? commentId,
    String? content,
    String? postId,
    String? author,
    String? uid,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profilePic,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      content: content ?? this.content,
      postId: postId ?? this.postId,
      author: author ?? this.author,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profilePic: profilePic ?? this.profilePic,
    );
  }
}
