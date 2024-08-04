import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.points,
    required this.fullName,
    this.profilePic,
    this.bio,
    this.groupIds = const [],
    this.enrolledCourseIds = const [],
    this.following = const [],
    this.followers = const [],
    this.timetableIds = const [],
    this.blockedUids = const [],
  });

  const LocalUser.empty()
      : this(
          uid: '',
          email: '',
          points: 0,
          fullName: '',
          profilePic: '',
          bio: '',
          groupIds: const [],
          enrolledCourseIds: const [],
          following: const [],
          followers: const [],
          timetableIds: const [],
          blockedUids: const [],
        );

  @override
  String toString() {
    return 'LocalUser{uid: $uid, email: $email, bio: $bio, fullName: '
        '$fullName}';
  }

  final String uid;
  final String email;
  final String? profilePic;
  final String? bio;
  final int points;
  final String fullName;
  final List<String> groupIds;
  final List<String> enrolledCourseIds;
  final List<String> following;
  final List<String> followers;
  final List<String> timetableIds;
  final List<String> blockedUids;

  @override
  List<dynamic> get props => [
        uid,
        email,
        profilePic,
        bio,
        points,
        fullName,
        groupIds.length,
        enrolledCourseIds.length,
        following.length,
        followers.length,
        timetableIds.length,
        blockedUids.length,
      ];
}
