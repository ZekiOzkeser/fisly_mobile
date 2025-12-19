import '../../../core/storage/token_store.dart';
import 'auth_api.dart';

class AuthRepository {
  final AuthApi _api;
  final TokenStore _tokenStore;

  AuthRepository(this._api, this._tokenStore);

  Future<void> login({required String email, required String password}) async {
    final data = await _api.login(email: email, password: password);

    // Backend contract:
    // { accessToken: "...", refreshToken: "..." }
    final access = data['accessToken'] as String;
    final refresh = data['refreshToken'] as String;

    await _tokenStore.save(access: access, refresh: refresh);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final data = await _api.register(
      name: name,
      email: email,
      password: password,
    );

    final access = data['accessToken'] as String;
    final refresh = data['refreshToken'] as String;

    await _tokenStore.save(access: access, refresh: refresh);
  }

  Future<bool> hasSession() async {
    final token = await _tokenStore.readAccess();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() => _tokenStore.clear();
}
