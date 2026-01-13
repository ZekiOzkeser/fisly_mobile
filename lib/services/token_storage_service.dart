import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure token storage service using encrypted storage
/// Handles JWT token persistence with platform-specific encryption
class TokenStorageService {
  static const String _tokenKey = 'fisly_jwt_token';
  static const String _userIdKey = 'fisly_user_id';

  final FlutterSecureStorage _secureStorage;

  TokenStorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Save JWT access token securely
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  /// Retrieve JWT access token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  /// Save current user id
  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(key: _userIdKey, value: userId);
  }

  /// Retrieve current user id
  Future<String?> getUserId() async {
    return await _secureStorage.read(key: _userIdKey);
  }

  /// Clear all stored tokens and user data
  Future<void> clearAll() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _userIdKey);
  }

  /// Check if user has valid token
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
