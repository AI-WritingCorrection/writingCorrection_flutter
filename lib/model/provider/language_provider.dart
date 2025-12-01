import 'dart:developer' as developer; // 로깅을 위한 developer 패키지 임포트
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 앱의 언어(Locale) 설정을 관리하고, 변경 사항을 UI에 알리는 Provider 클래스입니다.
/// 이 클래스는 `shared_preferences`를 사용하여 사용자의 언어 선택을 저장하고 불러옵니다.
class LanguageProvider with ChangeNotifier {
  // 현재 앱에 적용된 Locale을 저장하는 변수입니다.
  Locale? _appLocale;

  /// 현재 앱의 Locale을 반환합니다.
  Locale? get appLocale => _appLocale;

  /// LanguageProvider의 생성자입니다.
  /// 초기 Locale을 직접 설정하거나, 저장된 Locale을 불러와 초기화합니다.
  LanguageProvider({Locale? initialLocale}) {
    // initialLocale이 제공되면 해당 Locale로 초기화하고 저장합니다.
    if (initialLocale != null) {
      _appLocale = initialLocale;
      _saveLocale(initialLocale).then((_) {
        developer.log('초기 Locale이 $initialLocale로 설정되고 저장되었습니다.', name: 'LanguageProvider');
      }).catchError((e, st) {
        developer.log('초기 Locale 저장 중 오류 발생: $e', name: 'LanguageProvider', error: e, stackTrace: st);
      });
    } else {
      // initialLocale이 없으면 저장된 Locale을 로드합니다.
      loadLocale().then((_) {
        developer.log('저장된 Locale을 로드하여 초기화되었습니다: $_appLocale', name: 'LanguageProvider');
      }).catchError((e, st) {
        developer.log('Locale 로드 중 오류 발생: $e', name: 'LanguageProvider', error: e, stackTrace: st);
      });
    }
  }

  /// 현재 Locale을 `shared_preferences`에 저장합니다.
  /// [locale]: 저장할 Locale 객체입니다.
  Future<void> _saveLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', locale.languageCode);
      developer.log('Locale 저장 성공: ${locale.languageCode}', name: 'LanguageProvider');
    } catch (e, st) {
      developer.log('Locale 저장 실패: $e', name: 'LanguageProvider', error: e, stackTrace: st);
      // 에러 처리를 사용자에게 알리거나 재시도 로직을 추가할 수 있습니다.
    }
  }

  /// 앱의 언어를 변경하고, 변경된 Locale을 저장한 후 UI에 알립니다.
  /// [newLocale]: 새로 설정할 Locale 객체입니다.
  void changeLanguage(Locale newLocale) async {
    // 현재 Locale과 동일하면 변경 작업을 수행하지 않습니다.
    if (_appLocale == newLocale) {
      developer.log('현재 Locale과 동일합니다. 변경하지 않습니다.', name: 'LanguageProvider');
      return;
    }
    
    _appLocale = newLocale; // 새 Locale 설정
    await _saveLocale(newLocale); // 새 Locale 저장
    developer.log('Locale 변경 성공: $_appLocale', name: 'LanguageProvider');
    notifyListeners(); // UI 업데이트를 위해 리스너에게 알립니다.
  }

  /// `shared_preferences`에서 저장된 Locale을 불러와 앱에 적용합니다.
  /// 저장된 Locale이 없으면 기본값인 'ko'(한국어)를 사용합니다.
  Future<void> loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? languageCode = prefs.getString('language_code');

      if (languageCode != null) {
        _appLocale = Locale(languageCode);
        developer.log('저장된 Locale 로드 성공: $languageCode', name: 'LanguageProvider');
      } else {
        _appLocale = const Locale('ko'); // 저장된 값이 없으면 기본값인 한국어로 설정
        developer.log('저장된 Locale이 없어 기본 Locale(ko)로 설정되었습니다.', name: 'LanguageProvider');
      }
    } catch (e, st) {
      developer.log('Locale 로드 실패: $e', name: 'LanguageProvider', error: e, stackTrace: st);
      _appLocale = const Locale('ko'); // 에러 발생 시에도 기본 Locale 설정
    } finally {
      notifyListeners(); // 로드 완료 후 UI 업데이트를 위해 리스너에게 알립니다.
    }
  }
}