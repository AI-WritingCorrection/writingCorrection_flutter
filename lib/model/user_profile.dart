import 'package:aiwriting_collection/model/typeEnum.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class UserProfile {
  final int userId;
  final String nickname;
  final String email;
  final String? profilePic;
  final DateTime birthdate;
  final UserType userType;

  UserProfile({
    required this.userId,
    required this.nickname,
    required this.email,
    this.profilePic,
    required this.birthdate,
    required this.userType,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] as int,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      profilePic: json['profile_pic'] as String?,
      birthdate: DateTime.parse(
        json['birthdate'] as String? ?? DateTime.now().toIso8601String(),
      ),
      userType: UserType.values.byName(json['user_type'] as String),
    );
  }
}

class UpdateProfile {
  final String? nickname;
  final DateTime? birthdate;
  final UserType? userType;

  UpdateProfile({this.nickname, this.birthdate, this.userType});

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (nickname != null) json['nickname'] = nickname;
    if (birthdate != null) json['birthdate'] = birthdate!.toIso8601String();
    if (userType != null) json['user_type'] = userType!.name;
    return json;
  }
}
