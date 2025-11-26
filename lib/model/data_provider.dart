import 'package:flutter/material.dart';
import 'package:aiwriting_collection/api.dart';
import 'package:aiwriting_collection/model/steps.dart';
import 'package:aiwriting_collection/model/mission_record.dart';

class DataProvider with ChangeNotifier {
  final Api _api = Api();

  List<Steps>? _steps;
  List<MissionRecord>? _missionRecords;
  bool _isLoading = false;
  String? _error;
  int? _lastLoadedUserId;

  List<Steps>? get steps => _steps;
  List<MissionRecord>? get missionRecords => _missionRecords;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetches non-user-specific data (the list of all steps)
  Future<void> loadInitialData() async {
    if (_steps != null) return; // Already loaded
    try {
      _steps = await _api.getStepList();
      print("✅ Steps loaded successfully: ${_steps?.length ?? 0} items");
      notifyListeners();
    } catch (e) {
      print("❌ Error loading initial steps: $e");
      _error = e.toString();
      notifyListeners();
    }
  }

  // Fetches user-specific data (mission progress)
  Future<void> loadMissionRecords(int userId) async {
    // Temporary fix: Ensure steps are loaded before loading user records.
    if (_steps == null) {
      print("ℹ️ Steps data is null. Attempting to load initial data first.");
      await loadInitialData();
    }

    if (_lastLoadedUserId == userId && _missionRecords != null) {
      print("ℹ️ Mission records for user $userId are already loaded.");
      return;
    }
    print("🔄 Loading mission records for user $userId...");
    _isLoading = true;
    _lastLoadedUserId = userId;
    // Clear old records before fetching new ones to prevent showing stale data
    _missionRecords = null; 
    _error = null;
    notifyListeners();

    try {
      _missionRecords = await _api.getMissionRecords(userId);
      print("✅ Mission records loaded successfully for user $userId: ${_missionRecords?.length ?? 0} items");
    } catch (e) {
      print("❌ Error loading mission records for user $userId: $e");
      _error = e.toString();
      _lastLoadedUserId = null; // Allow retry on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshMissionRecords(int userId) async {
    print("🔄 Refreshing mission records for user $userId...");
    _isLoading = true;
    notifyListeners();

    try {
      // Always fetch from API, bypassing any cache
      _missionRecords = await _api.getMissionRecords(userId);
      _lastLoadedUserId = userId; // Update the last loaded user ID
      print("✅ Mission records refreshed successfully for user $userId: ${_missionRecords?.length ?? 0} items");
    } catch (e) {
      print("❌ Error refreshing mission records for user $userId: $e");
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Only clears user-specific data
  void clearUserRecords() {
    print("ℹ️ Clearing user-specific records.");
    _missionRecords = null;
    _lastLoadedUserId = null;
    _error = null;
    notifyListeners();
  }
}
