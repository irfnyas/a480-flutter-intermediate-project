import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  final prefs = SharedPreferences.getInstance();

  static const kCacheUserId = 'kCacheUserId';
  static const kCacheName = 'kCacheName';
  static const kCacheToken = 'kCacheToken';

  Future<bool> isLoggedIn() async {
    return (await prefs).getString(kCacheToken) != null;
  }

  Future<String?> getString(String key) async {
    return (await prefs).getString(key);
  }

  Future<bool> setString(String key, String value) async {
    return (await prefs).setString(key, value);
  }

  Future<bool> clear() async {
    return (await prefs).clear();
  }
}
