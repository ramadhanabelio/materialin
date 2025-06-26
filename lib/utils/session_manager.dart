import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  static const _storage = FlutterSecureStorage();
  static const _adminTokenKey = 'admin_token';
  static const _userTokenKey = 'user_token';

  static Future<void> saveToken(String token, {bool isAdmin = true}) async {
    final key = isAdmin ? _adminTokenKey : _userTokenKey;
    await _storage.write(key: key, value: token);
  }

  static Future<String?> getToken({bool isAdmin = true}) async {
    final key = isAdmin ? _adminTokenKey : _userTokenKey;
    return await _storage.read(key: key);
  }

  static Future<void> clearToken({bool isAdmin = true}) async {
    final key = isAdmin ? _adminTokenKey : _userTokenKey;
    await _storage.delete(key: key);
  }
}
