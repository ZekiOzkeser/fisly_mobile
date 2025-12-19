import 'package:dio/dio.dart';
import '../../storage/token_store.dart';

class AuthInterceptor extends Interceptor {
  final TokenStore tokenStore;

  AuthInterceptor(this.tokenStore);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStore.readAccess();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
