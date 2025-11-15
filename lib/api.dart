import 'dart:convert';
import 'package:aiwriting_collection/model/mission_record.dart';
import 'package:aiwriting_collection/model/practice.dart';
import 'package:aiwriting_collection/model/stats.dart';
import 'package:aiwriting_collection/model/steps.dart';
import 'package:aiwriting_collection/model/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

//싱글톤 패턴 적용
class Api {
  static const _baseUrl = 'http://52.78.166.204/api';
  static Api? _instance;
  final http.Client _client;
  String? _jwt;

  // 로그인 후에 저장된 JWT
  Map<String, String> get _headers {
    final h = {'Content-Type': 'application/json'};
    if (_jwt != null) h['Authorization'] = 'Bearer $_jwt';
    return h;
  }

  Api._internal(this._client, this._jwt);

  factory Api({http.Client? client, String? jwt}) {
    _instance ??= Api._internal(client ?? http.Client(), jwt);
    return _instance!;
  }

  void setJwt(String? jwt) {
    _jwt = jwt;
  }

  // --- Helpers: normalize file input and infer content type ---
  String? _extractFilePath(dynamic fileRef) {
    if (fileRef == null) return null;
    if (fileRef is String) {
      var s = fileRef.trim();
      if (s.isEmpty) return null;
      // Handle file:// URIs (iOS/Android)
      if (s.startsWith('file://')) {
        try {
          s = Uri.parse(s).toFilePath();
        } catch (_) {}
      }
      return s;
    }
    if (fileRef is XFile) return fileRef.path;
    if (fileRef is File) return fileRef.path;
    return null;
  }

  MediaType _inferContentType(String path) {
    final p = path.toLowerCase();
    if (p.endsWith('.png')) return MediaType('image', 'png');
    if (p.endsWith('.webp')) return MediaType('image', 'webp');
    if(p.endsWith('.heic') || p.endsWith('.heif')) {
      return MediaType('image', 'heic');
    }
    // default jpeg (includes .jpg / .jpeg / unknown)
    return MediaType('image', 'jpeg');
  }

  /// 로그인
  Future<http.Response> login(String idToken) {
    return http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({'id_token': idToken}),
    );
  }

  Future<http.Response> logout() {
    return http.post(Uri.parse('$_baseUrl/auth/logout'), headers: _headers);
  }

  Future<http.Response> signup(Map<String, dynamic> payload) async {
    final uri = Uri.parse('$_baseUrl/auth/signup');
    final req = http.MultipartRequest('POST', uri);

    // JWT가 필요한 경우에만 Authorization 추가 (대부분의 signup은 불필요)
    if (_jwt != null) {
      req.headers['Authorization'] = 'Bearer $_jwt';
    }

    // 필수 필드 매핑 (키 변형도 수용)
    final idToken = payload['id_token'] ?? payload['idToken'];
    final provider = payload['provider'];
    final email = payload['email'];
    final nickname = payload['nickname'];
    final birthdate =
        payload['birthdate'] ??
        payload['birthdateIso'] ??
        payload['birthdate_iso'];

    if (idToken == null ||
        provider == null ||
        email == null ||
        nickname == null ||
        birthdate == null) {
      throw Exception(
        'signup payload 누락: id_token/provider/email/nickname/birthdate는 필수입니다.',
      );
    }

    req.fields.addAll({
      'id_token': idToken.toString(),
      'provider': provider.toString(),
      'email': email.toString(),
      'nickname': nickname.toString(),
      'birthdate': birthdate.toString(), // ISO 8601 문자열 기대
    });

    // 선택적 파일 업로드 (문자열/파일/XFile 모두 수용)
    final fileRef =
        payload['filePath'] ??
        payload['profile_pic_path'] ??
        payload['profile_pic'];
    final path = _extractFilePath(fileRef);
    if (path != null && path.trim().isNotEmpty) {
      // 존재 확인 (fromPath 에서 던지기 전에 미리 명확한 에러를 주자)
      if (!File(path).existsSync()) {
        throw Exception('프로필 이미지 파일을 찾을 수 없습니다: ' + path);
      }
      req.files.add(
        await http.MultipartFile.fromPath(
          'file',
          path,
          contentType: _inferContentType(path),
        ),
      );
    }

    final streamed = await req.send();
    return await http.Response.fromStream(streamed);
  }

  /// 글씨데이터를 서버에 전송하여 평가 결과를 받음
  Future<http.Response> submitResult(Map<String, dynamic> payload) {
    return http.post(
      Uri.parse('$_baseUrl/step/evaluate'),
      headers: _headers,
      body: jsonEncode(payload),
    );
  }

  /// 서버에서 스텝 목록을 가져와 Steps 객체로 반환합니다.
  Future<List<Steps>> getStepList() async {
    final res = await _client.get(
      Uri.parse('$_baseUrl/data/step'),
      headers: _headers,
    );
    if (res.statusCode != 200) {
      final decodedError = utf8.decode(res.bodyBytes);
      throw Exception('스텝 목록 조회 실패 (${res.statusCode}): $decodedError');
    }
    // **rawBytes** 를 UTF-8로 디코딩
    final decoded = utf8.decode(res.bodyBytes);
    final List<dynamic> jsonList = jsonDecode(decoded);
    return jsonList.map((e) => Steps.fromJson(e)).toList();
  }

  Future<List<Practice>> getPracticeList() async {
    final res = await _client.get(
      Uri.parse('$_baseUrl/data/practice'),
      headers: _headers,
    );
    if (res.statusCode != 200) {
      final decodedError = utf8.decode(res.bodyBytes);
      throw Exception('연습 목록 조회 실패 (${res.statusCode}): $decodedError');
    }
    final decoded = utf8.decode(res.bodyBytes);
    final List<dynamic> jsonList = jsonDecode(decoded);
    return jsonList.map((e) => Practice.fromJson(e)).toList();
  }

  Future<List<MissionRecord>> getMissionRecords(int userId) async {
    final res = await _client.get(
      Uri.parse('$_baseUrl/data/missionrecords/$userId'),
      headers: _headers,
    );
    if (res.statusCode != 200) {
      final decodedError = utf8.decode(res.bodyBytes);
      throw Exception('미션 기록 조회 실패 (${res.statusCode}): $decodedError');
    }
    final decoded = utf8.decode(res.bodyBytes);
    final List<dynamic> jsonList = jsonDecode(decoded);
    return jsonList.map((e) => MissionRecord.fromJson(e)).toList();
  }

  // 유저 공부기록 조회
  Future<List<Stats>> getUserStats(int userId) async {
    final res = await _client.get(
      Uri.parse('$_baseUrl/user/stats/$userId'),
      headers: _headers,
    );
    if (res.statusCode != 200) {
      final decodedError = utf8.decode(res.bodyBytes);
      throw Exception('유저 공부기록 조회 실패 (${res.statusCode}): $decodedError');
    }
    final decoded = utf8.decode(res.bodyBytes);
    final List<dynamic> jsonList = jsonDecode(decoded);
    return jsonList.map((e) => Stats.fromJson(e)).toList();
  }

  // 마이페이지 프로필 조회
  Future<UserProfile> getUserProfile(int userId) async {
    final res = await _client.get(
      Uri.parse('$_baseUrl/user/getProfile/$userId'),
      headers: _headers,
    );
    if (res.statusCode != 200) {
      final decodedError = utf8.decode(res.bodyBytes);
      throw Exception('프로필 조회 실패 (${res.statusCode}): $decodedError');
    }
    final raw = utf8.decode(res.bodyBytes);
    print('API raw response: $raw');
    final jsonMap = jsonDecode(raw);
    final payload =
        (jsonMap is Map<String, dynamic> && jsonMap.containsKey('data'))
            ? jsonMap['data']
            : jsonMap;
    return UserProfile.fromJson(payload);
  }

  // 프로필 정보 수정
  Future<void> updateProfile(UpdateProfile profile, int userId) async {
    final res = await _client.post(
      Uri.parse('$_baseUrl/user/updateProfile/$userId'),
      headers: _headers,
      body: jsonEncode(profile.toJson()),
    );
    if (res.statusCode != 200) {
      final decodedError = utf8.decode(res.bodyBytes);
      throw Exception('프로필 수정 실패 (${res.statusCode}): $decodedError');
    }
  }

  // 프로필 이미지 수정 (멀티파트 업로드, URL 반환)
  Future<String> uploadProfileImage(String pickedPath, int userId) async {
    final uri = Uri.parse('$_baseUrl/user/uploadProfileImage/$userId');
    final req = http.MultipartRequest('POST', uri);

    // JWT가 있다면 Authorization만 추가 (Content-Type은 MultipartRequest가 자동 설정)
    if (_jwt != null) {
      req.headers['Authorization'] = 'Bearer $_jwt';
    }

    // 필드명은 서버와 합의된 'file' 이어야 함
    req.files.add(
      await http.MultipartFile.fromPath(
        'file',
        pickedPath,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    final streamed = await req.send();
    final body = await streamed.stream.bytesToString();

    if (streamed.statusCode != 200) {
      throw Exception('프로필 이미지 업로드 실패 (${streamed.statusCode}): $body');
    }

    final decoded = jsonDecode(body);
    final data =
        (decoded is Map<String, dynamic> && decoded.containsKey('data'))
            ? decoded['data']
            : decoded;
    final String? url =
        (data is Map<String, dynamic>)
            ? (data['profile_pic_url'] as String? ?? data['url'] as String?)
            : null;
    if (url == null) {
      throw Exception('응답에 profile_pic_url이 없습니다: $body');
    }
    return url;
  }

  /// 글씨 평가 결과를 서버에 전송
  Future<http.Response> requestAiText(Map<String, dynamic> payload) {
    return http.post(
      Uri.parse('$_baseUrl/text/generate'),
      headers: _headers,
      body: jsonEncode(payload),
    );
  }
}



// 여기에 다른 /practice, /step 등 필요한 API 메서드를 계속 추가…
