import 'dart:convert';
import 'package:aiwriting_collection/api.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginStatus extends ChangeNotifier {
  final api = Api();

  int? _userId;
  int? get userId => _userId;

  // 로그인 여부를 관리하는 변수 (초기값은 false)
  bool _isLoggedIn = false;

  // 외부에서 로그인 상태를 읽을 수 있는 getter
  bool get isLoggedIn => _isLoggedIn;

  String? _firebaseIdToken;
  String? _firebaseUid;
  String? _jwt;
  String? _provider;
  String? _email;

  String? get firebaseIdToken => _firebaseIdToken;
  String? get uid => _firebaseUid;
  String? get jwt => _jwt;
  String? get lastProvider => _provider;
  String? get email => _email;

  // 테스트용 게스트 로그인
  void loginAsGuest(String guestUid) {
    _firebaseUid = guestUid;
    _isLoggedIn = true;
    notifyListeners();
  }

  // 서버에서 받은 사용자 정보로 로그인 상태 설정
  void setUser({
    required int userId,
    required String uid,
    required String jwt,
    String? email,
  }) {
    _userId = userId;
    _firebaseUid = uid;
    _jwt = jwt;
    _email = email;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<String?> _signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google [UserCredential]
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // Retrieve the Firebase ID token
      final String? idToken =
          await FirebaseAuth.instance.currentUser?.getIdToken();
      _firebaseIdToken = idToken;
      _firebaseUid = userCredential.user?.uid;
      _email = userCredential.user?.email;
      return _firebaseUid;
    } catch (e, st) {
      print('Google sign-in error: $e');
      return null;
    }
  }

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
      String? idToken = await auth.currentUser!.getIdToken();
      _firebaseIdToken = idToken;
      _email = userCredential.user?.email;
      return userCredential.user?.uid;
    } catch (e, st) {
      print('Apple sign-in error: $e');
      return null;
    }
  }

  Future<String?> _signInWithKakao() async {
    print('[1] _signInWithKakao 진입');
    try {
      print('[2] Kakao sign-in 시작');
      //final auth = FirebaseAuth.instance;
      // 1) OIDC 인증을 통해 액세스 토큰 및 ID 토큰을 발급받습니다
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('[3] access token: ${token.accessToken}');
      print('ID Token: ${token.idToken}');
      // 2)Firebase 크레덴셜 생성
      var provider = OAuthProvider('oidc.kakao');
      var credential = provider.credential(
        idToken: token.idToken,
        // 카카오 로그인에서 발급된 idToken(카카오 설정에서 OpenID Connect가 활성화 되어있어야함)
        accessToken: token.accessToken, // 카카오 로그인에서 발급된 accessToken
      );
      print('[4] Firebase 크레덴셜 생성 완료: $credential');
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      print('[5] 얻은 ID 토큰: ${userCredential.credential?.token}');
      // 4) 로그인된 유저를 가져왔는지 확인
      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'NO_USER',
          message: 'Firebase 로그인 실패: user 가 null 입니다.',
        );
      }

      // 5) Firebase ID 토큰을 가져와 저장
      final idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
      print('[6] 얻은 ID 토큰: $idToken');
      _firebaseIdToken = idToken;
      _firebaseUid = user.uid;
      _email = FirebaseAuth.instance.currentUser?.email;
      print('email=$_email');
      return _firebaseUid;
    } catch (e, st) {
      print('[ERROR] 카카오 로그인 실패: $e\n$st');
      return null;
    }
  }

  Future<bool> loginWithProvider(String provider) async {
    try {
      String? uid;
      print("[loginWithProvider] incoming provider argument: $provider");
      _provider = provider;
      print("[loginWithProvider] internal _provider set to: $_provider");
      switch (provider) {
        case 'GOOGLE':
          uid = await _signInWithGoogle();
          break;
        case 'APPLE':
          uid = await _signInWithApple();
          break;
        case 'KAKAO':
          uid = await _signInWithKakao();
          break;
        default:
          throw Exception("Unknown provider: $provider");
      }

      if (uid != null) {
        final idToken = _firebaseIdToken;
        final res = await api.login(idToken!);
        print('Login successful with $provider, uid: $uid');
        if (res.statusCode == 200) {
          final body = jsonDecode(res.body);
          final jwt = jsonDecode(res.body)['jwt'];
          api.setJwt(jwt);
          setUser(
            userId: body['user_id'],
            uid: uid,
            jwt: body['jwt'],
            email: _email,
          );
          print('User logged in successfully: ${body['user_id']}');
          return true;
        } else if (res.statusCode == 404) {
          print('User not found, redirecting to signup');
          return false;
        } else {
          throw Exception('Server error: ${res.statusCode} ${res.body}');
        }
      }
      throw Exception("Provider login failed");
    } catch (e) {
      print("loginWithProvider error: $e");
      rethrow;
    }
  }

  Future<void> logout() async {
    _userId = null;
    _firebaseUid = null;
    _isLoggedIn = false;
    _firebaseIdToken = null;
    _jwt = null;
    _email = null;

    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}

    try {
      await UserApi.instance.logout();
      print('Kakao 로그아웃 성공');
    } catch (e) {
      print('Kakao 로그아웃 실패: $e');
    }

    notifyListeners();
  }
}
