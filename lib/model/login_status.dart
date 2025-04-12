import 'package:flutter/material.dart';

class LoginStatus extends ChangeNotifier {
  // 로그인 여부를 관리하는 변수 (초기값은 false)
  bool _isLoggedIn = false;

  // 외부에서 로그인 상태를 읽을 수 있는 getter
  bool get isLoggedIn => _isLoggedIn;

  // 로그인 상태를 변경하는 메서드
  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    // 상태 변경을 알리기 위해 notifyListeners 호출
    notifyListeners();
  }
}