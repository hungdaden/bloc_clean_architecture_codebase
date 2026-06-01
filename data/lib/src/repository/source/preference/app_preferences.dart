import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton()
class AppPreferences with LogMixin {
  AppPreferences(this._sharedPreference)
      : _encryptedSharedPreferences = EncryptedSharedPreferences(prefs: _sharedPreference);

  final SharedPreferences _sharedPreference;
  final EncryptedSharedPreferences _encryptedSharedPreferences;

  bool get isDarkMode {
    return _sharedPreference.getBool(SharedPreferenceKeys.isDarkMode) ?? false;
  }

  String get deviceToken {
    return _sharedPreference.getString(SharedPreferenceKeys.deviceToken) ?? '';
  }

  String get languageCode => _sharedPreference.getString(SharedPreferenceKeys.languageCode) ?? '';

  bool get isFirstLaunchApp =>
      _sharedPreference.getBool(SharedPreferenceKeys.isFirstLaunchApp) ?? true;

  Future<bool> saveLanguageCode(String languageCode) {
    return _sharedPreference.setString(SharedPreferenceKeys.languageCode, languageCode);
  }

  Future<bool> saveIsFirsLaunchApp(bool isFirstLaunchApp) {
    return _sharedPreference.setBool(SharedPreferenceKeys.isFirstLaunchApp, isFirstLaunchApp);
  }

  Future<bool> saveIsDarkMode(bool isDarkMode) {
    return _sharedPreference.setBool(SharedPreferenceKeys.isDarkMode, isDarkMode);
  }

  Future<bool> saveDeviceToken(String token) {
    return _sharedPreference.setString(SharedPreferenceKeys.deviceToken, token);
  }
}
