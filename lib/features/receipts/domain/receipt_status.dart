enum ReceiptStatus { uploaded, ocr, ai, ready, error }

extension ReceiptStatusX on ReceiptStatus {
  String get key => name;

  String get label => switch (this) {
    ReceiptStatus.uploaded => 'Yüklendi',
    ReceiptStatus.ocr => 'OCR',
    ReceiptStatus.ai => 'AI',
    ReceiptStatus.ready => 'Hazır',
    ReceiptStatus.error => 'Hata',
  };

  static ReceiptStatus fromKey(String key) {
    return ReceiptStatus.values.firstWhere(
      (e) => e.key == key,
      orElse: () => ReceiptStatus.uploaded,
    );
  }
}
