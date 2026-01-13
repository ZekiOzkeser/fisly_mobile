import 'package:dio/dio.dart';

import '../models/auth_models.dart';
import './api_client.dart';

/// Authentication service for Fisly API
/// Handles login, register, verify, password reset with JWT token management
class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<LoginResponse> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final request = LoginRequest(identifier: identifier, password: password);

      final response = await _apiClient.dio.post(
        '/auth/login',
        data: request.toJson(),
      );

      final apiResponse = ApiResponse<LoginData>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => LoginData.fromJson(data),
      );

      if (apiResponse.success && apiResponse.data != null) {
        await _apiClient.saveToken(apiResponse.data!.token);
        await _apiClient.tokenStorage.saveUserId(apiResponse.data!.user.id);
      }

      return LoginResponse(
        success: apiResponse.success,
        message: apiResponse.message,
        data: apiResponse.data!,
        error: apiResponse.error,
      );
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  Future<RegisterResponse> register({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final request = RegisterRequest(
        email: email,
        username: username,
        password: password,
      );

      final response = await _apiClient.dio.post(
        '/auth/register',
        data: request.toJson(),
      );

      final apiResponse = ApiResponse<RegisterResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => RegisterResponse.fromJson(data),
      );

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  Future<String> verifyEmail(String token) async {
    try {
      final response = await _apiClient.dio.get(
        '/auth/verify',
        queryParameters: {'token': token},
      );

      return response.data as String;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  Future<ResendVerificationResponse> resendVerification({
    required String email,
  }) async {
    try {
      final request = ResendVerificationRequest(email: email);

      final response = await _apiClient.dio.post(
        '/auth/resend-verification',
        data: request.toJson(),
      );

      final apiResponse = ApiResponse<ResendVerificationResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => ResendVerificationResponse.fromJson(data),
      );

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  Future<PasswordResetResponse> requestPasswordReset({
    required String email,
  }) async {
    try {
      final request = PasswordResetRequest(email: email);

      final response = await _apiClient.dio.post(
        '/auth/password-reset/request',
        data: request.toJson(),
      );

      final apiResponse = ApiResponse<PasswordResetResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => PasswordResetResponse.fromJson(data),
      );

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  Future<PasswordResetConfirmResponse> confirmPasswordReset({
    required String token,
    required String newPassword,
  }) async {
    try {
      final request = PasswordResetConfirmRequest(
        token: token,
        newPassword: newPassword,
      );

      final response = await _apiClient.dio.post(
        '/auth/password-reset/confirm',
        data: request.toJson(),
      );

      final apiResponse = ApiResponse<PasswordResetConfirmResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => PasswordResetConfirmResponse.fromJson(data),
      );

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  Future<AuthMeResponse> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get('/auth/me');

      final apiResponse = ApiResponse<AuthMeResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => AuthMeResponse.fromJson(data),
      );

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  Future<void> logout() async {
    await _apiClient.clearToken();
  }

  Future<bool> isAuthenticated() async {
    return await _apiClient.isAuthenticated();
  }
}
