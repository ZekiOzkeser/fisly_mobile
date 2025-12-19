import 'dart:math';
import 'package:image_picker/image_picker.dart';

import '../domain/receipt.dart';
import '../domain/receipt_category.dart';
import '../domain/receipt_status.dart';
import 'receipts_repository.dart';

class FakeReceiptsRepository implements ReceiptsRepository {
  final _rnd = Random();
  final Map<String, Receipt> _store = {};

  FakeReceiptsRepository() {
    _seed('2024-12');
    _seed('2025-01');
    _seed('2025-02');
  }

  void _seed(String month) {
    for (int i = 0; i < 6; i++) {
      final id = '$month-$i';
      final status =
          ReceiptStatus.values[_rnd.nextInt(ReceiptStatus.values.length - 1)];
      _store[id] = Receipt(
        id: id,
        month: month,
        status: status,
        amount: (_rnd.nextInt(900) + 50).toDouble(),
        merchant: [
          'Migros',
          'Shell',
          'Trendyol',
          'Yemeksepeti',
          'Metro',
        ][_rnd.nextInt(5)],
        date: DateTime.now().subtract(Duration(days: _rnd.nextInt(25))),
        category:
            ReceiptCategory.values[_rnd.nextInt(ReceiptCategory.values.length)],
        note: _rnd.nextBool() ? 'AI önerisi: iş yemeği' : '',
      );
    }
  }

  @override
  Future<List<Receipt>> listByMonth(String month) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _store.values.where((r) => r.month == month).toList()..sort(
      (a, b) => (b.date ?? DateTime(2000)).compareTo(a.date ?? DateTime(2000)),
    );
  }

  @override
  Future<Receipt> getById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final r = _store[id];
    if (r == null) throw Exception('Receipt not found');
    return r;
  }

  @override
  Future<Receipt> update({
    required String id,
    ReceiptCategory? category,
    String? note,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final r = _store[id];
    if (r == null) throw Exception('Receipt not found');

    final updated = r.copyWith(
      category: category ?? r.category,
      note: note ?? r.note,
      status:
          ReceiptStatus.ready, // edit sonrası "hazır" yapıyoruz (demo hissi)
    );

    _store[id] = updated;
    return updated;
  }

  @override
  Future<Receipt> upload({
    required String month,
    XFile? image,
    String? pdfPath,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final id = '${month}-${DateTime.now().millisecondsSinceEpoch}';
    final receipt = Receipt(
      id: id,
      month: month,
      status: ReceiptStatus.uploaded,
      amount: null,
      merchant: image != null ? 'Yeni Fiş (Foto)' : 'Yeni Fiş (PDF)',
      date: DateTime.now(),
      category: ReceiptCategory.other,
      note: '',
    );

    _store[id] = receipt;
    return receipt;
  }
}
