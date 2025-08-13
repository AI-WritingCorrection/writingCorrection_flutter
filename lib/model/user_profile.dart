class UserProfile {
  final int userId;
  final String nickname;
  final String email;
  final String? profilePic;

  UserProfile({
    required this.userId,
    required this.nickname,
    required this.email,
    this.profilePic,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] as int,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      profilePic: json['profile_pic'] as String?,
    );
  }
}
