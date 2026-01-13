import 'package:dio/dio.dart';

import './token_storage_service.dart';

/// Authentication interceptor for automatic JWT token injection
/// Adds Bearer token to all requests automatically
class AuthInterceptor extends Interceptor {
  final TokenStorageService _tokenStorage;

  AuthInterceptor(this._tokenStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Automatically clears tokens on authentication failures
class ErrorInterceptor extends Interceptor {
  final TokenStorageService _tokenStorage;
  final void Function()? onUnauthorized;

  ErrorInterceptor(this._tokenStorage, {this.onUnauthorized});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      await _tokenStorage.clearAll();
      onUnauthorized?.call();
    }
    handler.next(err);
  }
}

/// Basic logging interceptor for debugging API calls
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ignore: avoid_print
    print('[DIO] => ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ignore: avoid_print
    print('[DIO] <= ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }
}
