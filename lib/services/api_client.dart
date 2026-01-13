import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import './dio_interceptors.dart';
import './token_storage_service.dart';
import './platform_adapter.dart';

/// Professional Dio HTTP client with JWT Bearer authentication
/// Implements clean architecture with interceptors and error handling
class ApiClient {
  late final Dio _dio;
  final TokenStorageService _tokenStorage;

  static const String _envBaseUrl = String.fromEnvironment(
    'FISLY_API_BASE_URL',
    defaultValue: '',
  );

  static String get baseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;

    if (kIsWeb) {
      return 'http://localhost:5077';
    }

    if (isAndroid) {
      return 'http://10.0.2.2:5077';
    }

    return 'http://localhost:5077';
  }

  ApiClient({TokenStorageService? tokenStorage})
      : _tokenStorage = tokenStorage ?? TokenStorageService() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(_tokenStorage),
      ErrorInterceptor(_tokenStorage, onUnauthorized: _handleUnauthorized),
      LoggingInterceptor(),
    ]);
  }

  void _handleUnauthorized() {
    // ignore: avoid_print
    print('Unauthorized access detected - tokens cleared');
  }

  Dio get dio => _dio;

  TokenStorageService get tokenStorage => _tokenStorage;

  Future<void> saveToken(String token) async {
    await _tokenStorage.saveToken(token);
  }

  Future<String?> getToken() async {
    return await _tokenStorage.getToken();
  }

  Future<void> clearToken() async {
    await _tokenStorage.clearAll();
  }

  Future<bool> isAuthenticated() async {
    return await _tokenStorage.hasToken();
  }

  static String handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      if (data is Map && data.containsKey('message')) {
        return data['message'] as String;
      }

      switch (statusCode) {
        case 400:
          return 'Geçersiz istek. Lütfen bilgilerinizi kontrol edin.';
        case 401:
          return 'Oturum süreniz dolmuş. Lütfen tekrar giriş yapın.';
        case 403:
          return 'Bu işlem için yetkiniz yok veya hesabınız pasif.';
        case 404:
          return 'İstenen kaynak bulunamadı.';
        case 409:
          return 'Bu kayıt zaten mevcut.';
        case 413:
          return 'Dosya boyutu çok büyük.';
        case 415:
          return 'Desteklenmeyen dosya formatı.';
        default:
          return 'Bir hata oluştu ($statusCode). Lütfen tekrar deneyin.';
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Bağlantı zaman aşımına uğradı. İnternet bağlantınızı kontrol edin.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'Bağlantı hatası. İnternet bağlantınızı kontrol edin.';
    }

    return 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';
  }
}
