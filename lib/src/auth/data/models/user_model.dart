import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/auth/domain/entities/user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.points,
    required super.fullName,
    super.profilePic,
    super.bio,
    super.enrolledCourseIds,
    super.followers,
    super.following,
    super.groupIds,
  });

  const LocalUserModel.empty()
      : this(
          uid: '',
          email: '',
          points: 0,
          fullName: '',
          profilePic: '',
          bio: '',
        );

  LocalUserModel.fromMap(DataMap map)
      : super(
          uid: map['uid'] as String,
          email: map['email'] as String,
          points: (map['points'] as num).toInt(),
          fullName: map['fullName'] as String,
          profilePic: map['profilePic'] as String?,
          bio: map['bio'] as String?,
          groupIds: (map['groupIds'] as List<dynamic>).cast<String>(),
          enrolledCourseIds:
              (map['enrolledCourseIds'] as List<dynamic>).cast<String>(),
          following: (map['following'] as List<dynamic>).cast<String>(),
          followers: (map['followers'] as List<dynamic>).cast<String>(),
        );

  LocalUserModel copyWith({
    String? uid,
    String? email,
    int? points,
    String? fullName,
    String? profilePic,
    String? bio,
    List<String>? enrolledCourseIds,
    List<String>? followers,
    List<String>? following,
    List<String>? groupIds,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      points: points ?? this.points,
      fullName: fullName ?? this.fullName,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      groupIds: groupIds ?? this.groupIds,
    );
  }

  DataMap toMap() => {
        'uid': uid,
        'email': email,
        'points': points,
        'fullName': fullName,
        'profilePic': profilePic,
        'bio': bio,
        'groupIds': groupIds,
        'enrolledCourseIds': enrolledCourseIds,
        'following': following,
        'followers': followers,
      };
}
