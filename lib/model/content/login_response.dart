import 'package:aiwriting_collection/model/common/type_enum.dart';

/// 로그인 API 응답을 위한 데이터 모델
/// 서버로부터 받은 사용자 로그인 정보를 Dart 객체로 변환합니다.
class LoginResponse {
  /// 백엔드에서 관리되는 사용자 고유 ID
  final int userId;

  /// Firebase 인증 시스템에서 사용되는 사용자 고유 ID (UID)
  final String firebaseUid;

  /// 백엔드 API 요청 시 사용되는 인증 토큰 (JSON Web Token)
  final String jwt;

  /// 사용자의 이메일 주소 (선택 사항일 수 있음)
  final String? email;

  /// 사용자의 유형 (예: CHILD, ADULT, FOREIGN)
  final UserType? userType;

  /// LoginResponse 인스턴스를 생성하는 생성자
  LoginResponse({
    required this.userId,
    required this.firebaseUid,
    required this.jwt,
    this.email,
    this.userType,
  });

  /// JSON 맵으로부터 LoginResponse 객체를 생성하는 팩토리 생성자
  /// 서버 응답 데이터를 Dart 객체로 편리하게 변환할 수 있도록 합니다.
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['user_id'] as int,
      firebaseUid: json['firebase_uid'] as String,
      jwt: json['jwt'] as String,
      email: json['email'] as String?,
      userType: json['user_type'] != null
          ? UserType.values.firstWhere(
              (e) => e.name == (json['user_type'] as String),
              orElse: () => UserType.CHILD, // 기본값 설정: 알 수 없는 user_type일 경우 CHILD로 처리
            )
          : null,
    );
  }

  /// LoginResponse 객체를 JSON 맵으로 변환하는 메서드 (선택 사항, 필요 시 사용)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'firebase_uid': firebaseUid,
      'jwt': jwt,
      'email': email,
      'user_type': userType?.name, // Enum 값을 문자열로 변환
    };
  }
}
