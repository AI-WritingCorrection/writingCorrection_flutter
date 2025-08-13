import 'dart:convert';
import 'package:aiwriting_collection/model/mission_record.dart';
import 'package:aiwriting_collection/model/practice.dart';
import 'package:aiwriting_collection/model/steps.dart';
import 'package:aiwriting_collection/model/typeEnum.dart';
import 'package:aiwriting_collection/model/user_profile.dart';
import 'package:http/http.dart' as http;

//싱글톤 패턴 적용
class Api {
  static const _baseUrl = 'http://52.78.166.204:8000/api';
  //안드로이드용
  //static const _baseUrl = 'http://10.0.2.2:8000/api';

  //iOS용
  //static const _baseUrl = 'http://localhost:8000/api';

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

  Future<http.Response> signup(Map<String, dynamic> payload) {
    return http.post(
      Uri.parse('$_baseUrl/auth/signup'),
      headers: _headers,
      body: jsonEncode(payload),
    );
  }

  /// 글씨 평가 결과를 서버에 전송
  Future<http.Response> submitResult(Map<String, dynamic> payload) {
    return http.post(
      Uri.parse('$_baseUrl/step/evaluate'),
      headers: _headers,
      body: jsonEncode(payload),
    );
  }

  //글씨 평가 채점 결과를 서버에 가져옴

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
    return jsonList
        .map(
          (e) => Steps(
            stepId: e['step_id'],
            stepMission: e['step_mission'],
            stepCharacter: e['step_character'], // 서버 필드명 그대로 사용
            stepType: WritingType.values.byName(e['step_type'] as String),
            stepText: e['step_text'],
            stepTime: e['step_time'] ?? 120,
          ),
        )
        .toList();
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
    return jsonList
        .map(
          (e) => Practice(
            practiceId: e['practice_id'],
            practiceCharacter: e['practice_character'],
            practiceType: WritingType.values.byName(
              e['practice_type'] as String,
            ),
            practiceText: e['practice_text'],
          ),
        )
        .toList();
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
    return jsonList
        .map(
          (e) => MissionRecord(
            stepId: e['step_id'] as int,
            userId: e['user_id'] as int,
            isCleared: e['isCleared'] as bool,
          ),
        )
        .toList();
  }

  // TODO: 마이페이지 프로필 조회
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
}

// 여기에 다른 /practice, /step 등 필요한 API 메서드를 계속 추가…
