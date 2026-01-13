import 'dart:io' if (dart.library.io) 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/receipt_models.dart';
import './api_client.dart';

/// Receipt service for Fisly API
/// All requests automatically include JWT Bearer token via interceptors
class ReceiptService {
  final ApiClient _apiClient;

  ReceiptService(this._apiClient);

  String? _validateFile(
    String? filePath,
    Uint8List? fileBytes,
    String fileName,
  ) {
    final extension = fileName.toLowerCase().split('.').last;
    final allowedExtensions = ['jpg', 'jpeg', 'png', 'pdf'];

    if (!allowedExtensions.contains(extension)) {
      return 'Desteklenmeyen dosya formatı. Sadece JPEG, PNG ve PDF dosyaları yüklenebilir.';
    }

    int? fileSize;
    if (kIsWeb && fileBytes != null) {
      fileSize = fileBytes.length;
    } else if (filePath != null) {
      try {
        fileSize = File(filePath).lengthSync();
      } catch (e) {
        return 'Dosya boyutu okunamadı.';
      }
    }

    if (fileSize != null && fileSize > 10 * 1024 * 1024) {
      return 'Dosya boyutu 10MB\'ı aşmamalıdır.';
    }

    return null;
  }

  Future<ReceiptUploadResponse> uploadReceipt({
    String? filePath,
    Uint8List? fileBytes,
    required String fileName,
  }) async {
    try {
      final validationError = _validateFile(filePath, fileBytes, fileName);
      if (validationError != null) {
        throw validationError;
      }

      String mimeType;
      final extension = fileName.toLowerCase().split('.').last;
      if (extension == 'pdf') {
        mimeType = 'application/pdf';
      } else if (extension == 'png') {
        mimeType = 'image/png';
      } else {
        mimeType = 'image/jpeg';
      }

      MultipartFile multipartFile;
      if (kIsWeb && fileBytes != null) {
        multipartFile = MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: DioMediaType.parse(mimeType),
        );
      } else if (filePath != null) {
        multipartFile = await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: DioMediaType.parse(mimeType),
        );
      } else {
        throw 'Dosya yüklenemedi. Lütfen tekrar deneyin.';
      }

      final formData = FormData.fromMap({'file': multipartFile});

      final response = await _apiClient.dio.post(
        '/receipts/upload',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {'Accept': 'application/json'},
        ),
      );

      return ReceiptUploadResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw 'Oturum süreniz dolmuş. Lütfen tekrar giriş yapın.';
      } else if (e.response?.statusCode == 413) {
        throw 'Dosya boyutu çok büyük. Maksimum 10MB yüklenebilir.';
      } else if (e.response?.statusCode == 415) {
        throw 'Desteklenmeyen dosya formatı. Sadece JPEG, PNG ve PDF dosyaları kabul edilir.';
      } else if (e.response?.statusCode == 500) {
        throw 'Sunucu hatası. Lütfen daha sonra tekrar deneyin.';
      }
      throw ApiClient.handleError(e);
    } catch (e) {
      if (e is String) {
        throw e;
      }
      throw 'Dosya yüklenirken bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }

  Future<ReceiptListResponse> getReceipts({
    String? query,
    int? status,
    String? range,
    String? from,
    String? to,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'pageSize': pageSize};

      if (query != null) queryParams['q'] = query;
      if (status != null) queryParams['status'] = status;
      if (range != null) queryParams['range'] = range;
      if (from != null) queryParams['from'] = from;
      if (to != null) queryParams['to'] = to;

      final response = await _apiClient.dio.get(
        '/receipts',
        queryParameters: queryParams,
      );

      return ReceiptListResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  Future<ReceiptDetailResponse> getParsedDetail(String receiptParsedId) async {
    try {
      final response = await _apiClient.dio.get(
        '/receipts/parsed/$receiptParsedId',
      );

      return ReceiptDetailResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  Future<Uint8List> getReceiptFile(String receiptId) async {
    try {
      final response = await _apiClient.dio.get(
        '/receipts/$receiptId/file',
        options: Options(responseType: ResponseType.bytes),
      );

      return response.data as Uint8List;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  Future<ReceiptManualViewDto> getManualView(String receiptId) async {
    try {
      final response = await _apiClient.dio.get('/receipts/$receiptId/manual');

      return ReceiptManualViewDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  Future<void> updateManualReceipt(
    String receiptId,
    ReceiptManualUpdateRequest request,
  ) async {
    try {
      await _apiClient.dio.put(
        '/receipts/$receiptId/manual',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  Future<List<ReceiptManualEditDto>> getManualEdits(String receiptId) async {
    try {
      final response = await _apiClient.dio.get(
        '/receipts/$receiptId/manual-edits',
      );

      return (response.data as List)
          .map(
            (edit) =>
                ReceiptManualEditDto.fromJson(edit as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  Future<void> sendToAccounting(String receiptId, String provider) async {
    try {
      await _apiClient.dio.post(
        '/receipts/$receiptId/send-to-accounting',
        queryParameters: {'provider': provider},
      );
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }
}
