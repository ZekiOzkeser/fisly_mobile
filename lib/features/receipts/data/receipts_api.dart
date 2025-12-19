import 'dart:io';
import 'package:dio/dio.dart';
import '../domain/receipt.dart';

class ReceiptsApi {
  final Dio _dio;
  ReceiptsApi(this._dio);

  Future<List<Receipt>> listByMonth(String month) async {
    final res = await _dio.get('/receipts', queryParameters: {'month': month});
    final items = (res.data as List).cast<Map<String, dynamic>>();
    return items.map(Receipt.fromJson).toList();
  }

  Future<Receipt> getOne(String id) async {
    final res = await _dio.get('/receipts/$id');
    return Receipt.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> update(String id, {String? category, String? note}) async {
    await _dio.put('/receipts/$id', data: {'category': category, 'note': note});
  }

  Future<Receipt> uploadFile({
    required File file,
    required String month,
  }) async {
    final form = FormData.fromMap({
      'month': month,
      'file': await MultipartFile.fromFile(file.path),
    });
    final res = await _dio.post('/receipts', data: form);
    return Receipt.fromJson(res.data as Map<String, dynamic>);
  }
}
