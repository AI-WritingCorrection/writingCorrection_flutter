import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:aiwriting_collection/api.dart';
import 'package:aiwriting_collection/model/content/steps.dart';
import 'package:aiwriting_collection/model/content/mission_record.dart';

/// 앱 전반의 주요 데이터(학습 단계, 미션 기록 등)를 관리하고 제공하는 Provider 클래스입니다.
/// 이 클래스는 ChangeNotifier를 상속받아 데이터 변경 시 UI에 알립니다.
class DataProvider with ChangeNotifier {
  // API 통신을 위한 인스턴스입니다. 외부에서 주입받을 수 있도록 하여 테스트 용이성을 높입니다.
  final Api _api;

  /// DataProvider의 생성자입니다.
  /// 선택적으로 Api 인스턴스를 주입받으며, 주입되지 않으면 기본 Api 인스턴스를 사용합니다.
  DataProvider({Api? api}) : _api = api ?? Api();

  // 모든 사용자에게 공통적으로 적용되는 학습 단계 데이터 목록입니다.
  List<Steps>? _steps;
  
  // 특정 사용자의 미션 기록 데이터 목록입니다.
  List<MissionRecord>? _missionRecords;
  
  // 데이터 로딩이 진행 중인지 여부를 나타내는 플래그입니다.
  bool _isLoading = false;
  
  // 데이터 로딩 중 발생한 에러 메시지를 저장합니다.
  String? _error;
  
  // 마지막으로 미션 기록을 로드했던 사용자의 ID를 저장하여 중복 로딩을 방지합니다.
  int? _lastLoadedUserId;

  /// 학습 단계 데이터 목록을 반환합니다.
  List<Steps>? get steps => _steps;
  /// 미션 기록 데이터 목록을 반환합니다.
  List<MissionRecord>? get missionRecords => _missionRecords;
  /// 데이터 로딩 중인지 여부를 반환합니다.
  bool get isLoading => _isLoading;
  /// 발생한 에러 메시지를 반환합니다.
  String? get error => _error;

  /// 초기 데이터(학습 단계 목록)를 로드합니다.
  /// 이 데이터는 사용자 비종속적이므로 앱 실행 중 한 번만 로드하면 됩니다.
  Future<void> loadInitialData() async {
    // 이미 로드된 경우 중복 호출을 방지합니다.
    if (_steps != null) {
      developer.log('초기 데이터(Steps)가 이미 로드되어 있습니다. 다시 로드하지 않습니다.', name: 'DataProvider');
      return; 
    }
    
    try {
      _steps = await _api.getStepList();
      developer.log('초기 데이터(Steps) 로드 성공: ${_steps?.length ?? 0} 건', name: 'DataProvider');
      notifyListeners(); // UI 업데이트를 위해 리스너에게 알립니다.
    } catch (e, st) {
      developer.log('초기 데이터(Steps) 로드 실패', name: 'DataProvider', error: e, stackTrace: st);
      _error = e.toString();
      notifyListeners(); // 에러 상태 변경을 UI에 알립니다.
    }
  }

  /// 특정 사용자의 미션 기록을 로드합니다.
  /// [userId]: 미션 기록을 조회할 사용자의 고유 ID입니다.
  Future<void> loadMissionRecords(int userId) async {
    // 미션 기록 로드 전에 학습 단계 데이터가 로드되어 있는지 확인하고, 없으면 로드 시도합니다.
    if (_steps == null) {
      developer.log('Steps 데이터가 없습니다. 미션 기록 로드 전에 초기 데이터 로드를 시도합니다.', name: 'DataProvider');
      await loadInitialData();
    }

    // 이미 해당 사용자의 데이터가 로드되어 있고 유효한 경우 중복 로드를 방지합니다.
    if (_lastLoadedUserId == userId && _missionRecords != null) {
      developer.log('사용자 $userId 의 미션 기록이 이미 로드되어 있습니다. 다시 로드하지 않습니다.', name: 'DataProvider');
      return;
    }

    developer.log('사용자 $userId 의 미션 기록 로딩 시작...', name: 'DataProvider');
    _isLoading = true; // 로딩 시작 상태로 변경
    _lastLoadedUserId = userId; // 마지막으로 로드할 사용자 ID 업데이트
    
    // 새로운 데이터를 불러오기 전에 기존 데이터를 초기화하여 혼동을 방지하고 UI에 로딩 상태를 표시합니다.
    _missionRecords = null; 
    _error = null;
    notifyListeners();

    try {
      _missionRecords = await _api.getMissionRecords(userId);
      developer.log('사용자 $userId 의 미션 기록 로드 성공: ${_missionRecords?.length ?? 0} 건', name: 'DataProvider');
    } catch (e, st) {
      developer.log('사용자 $userId 의 미션 기록 로드 실패', name: 'DataProvider', error: e, stackTrace: st);
      _error = e.toString();
      _lastLoadedUserId = null; // 에러 발생 시 재시도 가능하도록 사용자 ID 초기화
    } finally {
      _isLoading = false; // 로딩 완료 상태로 변경
      notifyListeners(); // UI 업데이트를 위해 리스너에게 알립니다.
    }
  }

  /// 특정 사용자의 미션 기록을 강제로 새로고침합니다.
  /// 기존 캐시를 무시하고 항상 API를 통해 최신 데이터를 가져옵니다.
  /// [userId]: 미션 기록을 새로고침할 사용자의 고유 ID입니다.
  Future<void> refreshMissionRecords(int userId) async {
    developer.log('사용자 $userId 의 미션 기록 새로고침 시작...', name: 'DataProvider');
    _isLoading = true; // 로딩 시작 상태로 변경
    notifyListeners(); // UI 업데이트를 위해 리스너에게 알립니다.

    try {
      // 캐시를 무시하고 API를 통해 최신 데이터를 가져옵니다.
      _missionRecords = await _api.getMissionRecords(userId);
      _lastLoadedUserId = userId; // 마지막으로 로드한 사용자 ID 업데이트
      developer.log('사용자 $userId 의 미션 기록 새로고침 성공: ${_missionRecords?.length ?? 0} 건', name: 'DataProvider');
    } catch (e, st) {
      developer.log('사용자 $userId 의 미션 기록 새로고침 실패', name: 'DataProvider', error: e, stackTrace: st);
      _error = e.toString();
    } finally {
      _isLoading = false; // 로딩 완료 상태로 변경
      notifyListeners(); // UI 업데이트를 위해 리스너에게 알립니다.
    }
  }

  /// 사용자별 미션 기록 데이터를 초기화합니다.
  /// 예를 들어, 사용자가 로그아웃할 때 호출하여 개인 데이터를 제거합니다.
  void clearUserRecords() {
    developer.log('사용자별 미션 기록 데이터 초기화 수행', name: 'DataProvider');
    _missionRecords = null;
    _lastLoadedUserId = null;
    _error = null;
    notifyListeners(); // UI 업데이트를 위해 리스너에게 알립니다.
  }
}