import 'dart:convert';
import 'dart:developer' as developer; // 로깅을 위한 developer 패키지 임포트
import 'package:aiwriting_collection/api.dart';
import 'package:aiwriting_collection/model/common/type_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

/// 로그인 상태를 관리하고 UI에 알리는 ChangeNotifier 클래스입니다.
/// 다양한 소셜 로그인(Google, Apple, Kakao)을 처리하고
/// Firebase 인증 및 백엔드 API와 연동합니다.
/// 
class LoginStatus extends ChangeNotifier {

  // API 통신을 위한 인스턴스. 의존성 주입을 통해 테스트 용이성을 높입니다.
  final Api _api;

  /// 생성자에서 Api 인스턴스를 주입받을 수 있습니다.
  /// 주입되지 않으면 기본 Api 인스턴스를 생성합니다.
  LoginStatus({Api? api}) : _api = api ?? Api();

  // 사용자 고유 ID (백엔드 DB 기준)
  int? _userId;
  int? get userId => _userId;

  // 로그인 여부를 관리하는 변수 (초기값은 false)
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  // 로그아웃 진행 중 여부 (중복 호출 방지)
  bool _isLoggingOut = false;
  bool get isLoggingOut => _isLoggingOut;

  // Firebase 및 인증 관련 정보
  String? _firebaseIdToken;
  String? _firebaseUid;
  String? _jwt;
  String? _provider; // 마지막으로 로그인한 제공자 (GOOGLE, APPLE, KAKAO)
  String? _email;
  UserType? _userType;

  String? get firebaseIdToken => _firebaseIdToken;
  String? get uid => _firebaseUid;
  String? get jwt => _jwt;
  String? get lastProvider => _provider;
  String? get email => _email;
  UserType? get userType => _userType;

  /// 테스트용 게스트 로그인 기능을 수행합니다.
  /// [guestUid]: 게스트 사용자의 UID
  void loginAsGuest(String guestUid) {
    _firebaseUid = guestUid;
    _isLoggedIn = true;
    developer.log('게스트 로그인 수행: $guestUid', name: 'LoginStatus');
    notifyListeners();
  }

  /// 서버에서 받은 사용자 정보로 로그인 상태를 설정합니다.
  /// [userId]: 백엔드 사용자 ID
  /// [uid]: Firebase UID
  /// [jwt]: 백엔드 인증 토큰
  /// [email]: 사용자 이메일
  /// [userType]: 사용자 유형 
  void setUser({
    required int userId,
    required String uid,
    required String jwt,
    String? email,
    UserType? userType,
  }) {
    _userId = userId;
    _firebaseUid = uid;
    _jwt = jwt;
    _email = email;
    _userType = userType;
    _isLoggedIn = true;
    
    // API 인스턴스에 JWT 설정
    _api.setJwt(jwt);
    
    developer.log(
      '사용자 정보 설정 완료: userId=$userId, uid=$uid, type=$userType', 
      name: 'LoginStatus'
    );
    notifyListeners();
  }

  /// 사용자 유형을 업데이트하고 UI를 갱신합니다.
  /// [newUserType]: 변경할 사용자 유형
  void updateUserType(UserType newUserType) {
    _userType = newUserType;
    developer.log('사용자 유형 업데이트: $newUserType', name: 'LoginStatus');
    notifyListeners();
  }

  /// 구글 로그인을 수행합니다.
  /// [forceAccountPicker]: true일 경우 기존 계정 연결을 끊고 계정 선택창을 강제로 띄웁니다.
  /// 성공 시 Firebase UID를 반환하고, 실패 시 null을 반환합니다.
  Future<String?> _signInWithGoogle({bool forceAccountPicker = false}) async {
    try {
      final g = GoogleSignIn();
      if (forceAccountPicker) {
        // 기존 기본 계정 연결을 끊어 계정 선택 창을 강제로 띄움
        await g.disconnect().catchError((e) {
          developer.log('Google disconnect 실패 (무시됨): $e', name: 'LoginStatus');
          return null;
        });
      }
      final GoogleSignInAccount? googleUser = await g.signIn();

      if (googleUser == null) {
        developer.log('사용자가 구글 로그인을 취소했습니다.', name: 'LoginStatus');
        return null;
      }

      // 구글 인증 정보 획득
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase 인증 자격 증명 생성
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase 로그인 수행
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // Firebase ID 토큰 및 사용자 정보 저장
      final String? idToken =
          await userCredential.user?.getIdToken();
      _firebaseIdToken = idToken;
      _firebaseUid = userCredential.user?.uid;
      _email =
          userCredential.user?.email ??
          FirebaseAuth.instance.currentUser?.email;
      
      developer.log('구글 로그인 성공: uid=$_firebaseUid', name: 'LoginStatus');
      return _firebaseUid;
    } catch (e, st) {
      developer.log('구글 로그인 오류', name: 'LoginStatus', error: e, stackTrace: st);
      return null;
    }
  }

  /// 애플 로그인을 수행합니다.
  /// 성공 시 Firebase UID를 반환하고, 실패 시 null을 반환합니다.
  Future<String?> _signInWithApple() async {
    try {
      final auth = FirebaseAuth.instance;
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      
      final userCredential = await auth.signInWithCredential(oauthCredential);
      
      // Null Safety 적용: currentUser! 대신 userCredential.user 사용
      String? idToken = await userCredential.user?.getIdToken();
      _firebaseIdToken = idToken;
      _email = userCredential.user?.email;
      
      developer.log('애플 로그인 성공: uid=${userCredential.user?.uid}', name: 'LoginStatus');
      return userCredential.user?.uid;
    } catch (e, st) {
      developer.log('애플 로그인 오류', name: 'LoginStatus', error: e, stackTrace: st);
      return null;
    }
  }

  /// 카카오 로그인을 수행합니다.
  /// 성공 시 Firebase UID를 반환하고, 실패 시 null을 반환합니다.
  Future<String?> _signInWithKakao() async {
    try {      
      // 1) 카카오 로그인 (OIDC 인증)
      // 카카오 개발자 콘솔에서 OpenID Connect가 활성화 되어있어야 합니다.
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      
      // 2) Firebase 크레덴셜 생성
      var provider = OAuthProvider('oidc.kakao');
      var credential = provider.credential(
        idToken: token.idToken,
        accessToken: token.accessToken,
      );

      // 3) Firebase 로그인
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      
      // 4) 로그인된 유저 확인 및 Null Safety 처리
      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'NO_USER',
          message: 'Firebase 로그인 실패: user 객체가 null 입니다.',
        );
      }

      // 5) Firebase ID 토큰을 가져와 저장
      final idToken = await user.getIdToken();
      developer.log('[6] Firebase ID 토큰 획득 완료', name: 'LoginStatus');
      
      _firebaseIdToken = idToken;
      _firebaseUid = user.uid;

      // 카카오 사용자 정보(이메일) 가져오기
      try {
        final kakaoUser = await UserApi.instance.me();
        developer.log('Kakao user object 획득 성공', name: 'LoginStatus');
        _email = kakaoUser.kakaoAccount?.email;
        developer.log('Kakao user email: $_email', name: 'LoginStatus');
      } catch (e) {
        developer.log('카카오 사용자 정보 획득 실패 (무시됨): $e', name: 'LoginStatus');
      }

      // Firebase 유저의 이메일이 비어있을 경우를 대비한 폴백 처리
      if (_email == null || _email!.isEmpty) {
        _email = FirebaseAuth.instance.currentUser?.email;
      }
      
      return _firebaseUid;
    } catch (e, st) {
      developer.log('[ERROR] 카카오 로그인 실패', name: 'LoginStatus', error: e, stackTrace: st);
      return null;
    }
  }

  /// 지정된 제공자를 통해 로그인을 수행하고 백엔드와 연동합니다.
  /// [provider]: 로그인 제공자 ('GOOGLE', 'APPLE', 'KAKAO')
  /// [forceAccountPicker]: 구글 로그인 시 계정 선택 강제 여부
  Future<Map<String, dynamic>?> loginWithProvider(
    String provider, {
    bool forceAccountPicker = false,
  }) async {
    try {
      String? uid;
      developer.log("[loginWithProvider] 요청된 provider: $provider", name: 'LoginStatus');
      _provider = provider;
      
      // String provider를 Enum으로 변환하여 안전하게 처리
      AuthProvider authProviderType;
      try {
        authProviderType = AuthProvider.values.byName(provider);
      } catch (_) {
         throw Exception("알 수 없는 provider: $provider");
      }

      switch (authProviderType) {
        case AuthProvider.GOOGLE:
          uid = await _signInWithGoogle(forceAccountPicker: forceAccountPicker);
          break;
        case AuthProvider.APPLE:
          uid = await _signInWithApple();
          break;        
        case AuthProvider.KAKAO:
          uid = await _signInWithKakao();
          break;
        default:
           // NAVER 등 아직 지원하지 않는 경우 처리
           throw Exception("지원하지 않는 provider: $provider");
      }

      if (uid == null) {
        developer.log('사용자에 의해 로그인이 취소되었습니다.', name: 'LoginStatus');
        return null;
      }

      final idToken = _firebaseIdToken;
      if (idToken == null) {
        throw Exception("Firebase ID Token이 존재하지 않습니다.");
      }

      // 백엔드 로그인 API 호출
      final res = await _api.login(idToken);
      developer.log('백엔드 로그인 응답 상태 코드: ${res.statusCode}, uid: $uid', name: 'LoginStatus');
      
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final jwt = body['jwt'];
        
        // 백엔드에서 받은 정보로 상태 설정
        setUser(
          userId: body['user_id'],
          uid: uid,
          jwt: jwt,
          email: _email,
          userType: UserType.values.firstWhere(
            (e) => e.name == (body['user_type'] as String),
            orElse: () {
              developer.log('알 수 없는 사용자 유형: ${body['user_type']}. 기본값 CHILD로 설정됩니다.', name: 'LoginStatus');
              return UserType.CHILD;
            },
          ),
        );
        
        developer.log('로그인 프로세스 완료 성공: userId=${body['user_id']}', name: 'LoginStatus');
        return {'success': true, 'email': _email};
      } else if (res.statusCode == 404) {
        developer.log('사용자 정보 없음, 회원가입 필요', name: 'LoginStatus');
        return {'success': false, 'email': _email};
      } else {
        throw Exception('서버 에러: ${res.statusCode} ${res.body}');
      }
    } catch (e, st) {
      developer.log("loginWithProvider 처리 중 오류 발생", name: 'LoginStatus', error: e, stackTrace: st);
      return null;
    }
  }

  /// 로그아웃을 수행합니다.
  /// 모든 소셜 로그인 연결을 해제하고 내부 상태를 초기화합니다.
  Future<void> logout() async {
    if (_isLoggingOut) return;

    _isLoggingOut = true;
    notifyListeners();

    try {
      developer.log('로그아웃 프로세스 시작', name: 'LoginStatus');
      
      // 상태 변수 초기화
      _userId = null;
      _firebaseUid = null;
      _isLoggedIn = false;
      _firebaseIdToken = null;
      _jwt = null;
      _email = null;
      _userType = null;
      
      // API 인스턴스 JWT 초기화
      _api.setJwt(''); // 또는 명시적인 clear 메소드가 있다면 사용

      // 병렬로 각 제공자의 로그아웃 수행 (하나가 실패해도 나머지는 진행)
      await Future.wait([
        FirebaseAuth.instance.signOut()
            .then((_) => true)
            .catchError((e) {
              developer.log('Firebase signOut 실패 (무시됨): $e', name: 'LoginStatus');
              return false;
            }),
        GoogleSignIn().disconnect()
            .then((_) => true)
            .catchError((e) {
              developer.log('Google disconnect 실패 (무시됨): $e', name: 'LoginStatus');
              return false;
            }),
        UserApi.instance.logout()
            .then((_) => true)
            .catchError((e) {
              developer.log('Kakao logout 실패 (무시됨): $e', name: 'LoginStatus');
              return false;
            }),
      ]);
      
      developer.log('로그아웃 성공', name: 'LoginStatus');

    } catch (e, st) {
      developer.log('로그아웃 실패', name: 'LoginStatus', error: e, stackTrace: st);
    } finally {
      _isLoggingOut = false;
      notifyListeners();
    }
  }
}