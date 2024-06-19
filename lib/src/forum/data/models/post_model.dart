import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/forum/domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.postId,
    required super.title,
    required super.upvotes,
    required super.downvotes,
    required super.commentCount,
    required super.author,
    required super.uid,
    required super.type,
    required super.createdAt,
    required super.updatedAt,
    super.content,
    super.link,
    super.tags,
  });

  PostModel.empty([DateTime? date])
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

  PostModel.fromMap(DataMap map)
      : this(
          postId: map['postId'] as String,
          title: map['title'] as String,
          upvotes: (map['upvotes'] as List<dynamic>).cast<String>(),
          downvotes: (map['downvotes'] as List<dynamic>).cast<String>(),
          commentCount: map['commentCount'] as int,
          author: map['author'] as String,
          uid: map['uid'] as String,
          type: map['type'] as String,
          createdAt: (map['createdAt'] as Timestamp).toDate(),
          updatedAt: (map['updatedAt'] as Timestamp).toDate(),
          content: map['content'] as String?,
          link: map['link'] as String?,
          tags: (map['tags'] as List<dynamic>).cast<String>(),
        );

  PostModel.fromJson(Map<String, dynamic> json)
      : this(
          postId: json['postId'] as String,
          title: json['title'] as String,
          upvotes: (json['upvotes'] as List<dynamic>).cast<String>(),
          downvotes: (json['downvotes'] as List<dynamic>).cast<String>(),
          commentCount: json['commentCount'] as int,
          author: json['author'] as String,
          uid: json['uid'] as String,
          type: json['type'] as String,
          createdAt:
              DateTime.fromMicrosecondsSinceEpoch(json['createdAt'] as int),
          updatedAt:
              DateTime.fromMicrosecondsSinceEpoch(json['updatedAt'] as int),
          tags: (json['tags'] as List<dynamic>).cast<String>(),
          content: json['content'] as String?,
          link: json['link'] as String?,
        );

  DataMap toMap() {
    return {
      'postId': postId,
      'title': title,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commentCount': commentCount,
      'author': author,
      'uid': uid,
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'content': content,
      'link': link,
      'tags': tags,
    };
  }

  PostModel copyWith({
    String? postId,
    String? title,
    List<String>? upvotes,
    List<String>? downvotes,
    int? commentCount,
    String? author,
    String? uid,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? content,
    String? link,
    List<String>? tags,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      title: title ?? this.title,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      commentCount: commentCount ?? this.commentCount,
      author: author ?? this.author,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      content: content ?? this.content,
      link: link ?? this.link,
      tags: tags ?? this.tags,
    );
  }
}
