import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/admin_user.dart';

class StorageService {
  static late SharedPreferences _prefs;
  static bool _initialized = false;

  // Initialize storage
  static Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  // Ensure initialized before use
  static Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await init();
    }
  }

  // Auth Token
  static Future<void> saveToken(String token) async {
    await _ensureInitialized();
    await _prefs.setString(AppConstants.storageToken, token);
  }

  static String? getToken() {
    return _prefs.getString(AppConstants.storageToken);
  }

  static Future<void> removeToken() async {
    await _ensureInitialized();
    await _prefs.remove(AppConstants.storageToken);
  }

  // Admin User
  static Future<void> saveUser(AdminUser user) async {
    await _ensureInitialized();
    await _prefs.setString(AppConstants.storageUser, jsonEncode(user.toJson()));
  }

  static AdminUser? getUser() {
    final userJson = _prefs.getString(AppConstants.storageUser);
    if (userJson != null) {
      return AdminUser.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  static Future<void> removeUser() async {
    await _ensureInitialized();
    await _prefs.remove(AppConstants.storageUser);
  }

  // Check if logged in
  static bool get isLoggedIn {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  // Theme Mode
  static Future<void> saveThemeMode(String themeMode) async {
    await _ensureInitialized();
    await _prefs.setString(AppConstants.storageTheme, themeMode);
  }

  static String getThemeMode() {
    return _prefs.getString(AppConstants.storageTheme) ?? 'light';
  }

  // Language
  static Future<void> saveLanguage(String language) async {
    await _ensureInitialized();
    await _prefs.setString(AppConstants.storageLanguage, language);
  }

  static String getLanguage() {
    return _prefs.getString(AppConstants.storageLanguage) ?? 'en';
  }

  // Clear all data (logout)
  static Future<void> clearAll() async {
    await _ensureInitialized();
    await _prefs.clear();
  }

  // Generic save/get methods
  static Future<void> saveString(String key, String value) async {
    await _ensureInitialized();
    await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<void> saveBool(String key, bool value) async {
    await _ensureInitialized();
    await _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static Future<void> saveInt(String key, int value) async {
    await _ensureInitialized();
    await _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  static Future<void> saveDouble(String key, double value) async {
    await _ensureInitialized();
    await _prefs.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  static Future<void> saveStringList(String key, List<String> value) async {
    await _ensureInitialized();
    await _prefs.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  static Future<void> remove(String key) async {
    await _ensureInitialized();
    await _prefs.remove(key);
  }

  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // NEW METHOD: Get all keys
  static Set<String> getAllKeys() {
    return _prefs.getKeys();
  }

  // NEW METHOD: Clear specific keys by pattern
  static Future<void> clearKeysByPattern(String pattern) async {
    await _ensureInitialized();
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.contains(pattern)) {
        await _prefs.remove(key);
      }
    }
  }

  // NEW METHOD: Get storage statistics
  static Map<String, dynamic> getStorageStats() {
    final keys = _prefs.getKeys();
    final stats = <String, dynamic>{
      'total_keys': keys.length,
      'keys': keys.toList(),
    };
    return stats;
  }

  // NEW METHOD: Check if storage is empty
  static bool get isEmpty {
    return _prefs.getKeys().isEmpty;
  }

  // NEW METHOD: Get storage size (approximate)
  static int getStorageSize() {
    final keys = _prefs.getKeys();
    int totalSize = 0;

    for (final key in keys) {
      final value = _prefs.get(key);
      if (value is String) {
        totalSize += key.length + value.length;
      } else if (value is int) {
        totalSize += key.length + 8; // Approximate size for int
      } else if (value is double) {
        totalSize += key.length + 8; // Approximate size for double
      } else if (value is bool) {
        totalSize += key.length + 1; // Approximate size for bool
      } else if (value is List<String>) {
        totalSize += key.length + value.join().length;
      }
    }

    return totalSize;
  }
}