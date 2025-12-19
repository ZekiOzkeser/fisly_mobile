class Receipt {
  final String id;
  final String month; // "2025-12"
  final String status; // uploaded/ocr/ai/ready/error
  final double? amount;
  final String? merchant;
  final DateTime? date;
  final String? category;
  final String? note;

  Receipt({
    required this.id,
    required this.month,
    required this.status,
    this.amount,
    this.merchant,
    this.date,
    this.category,
    this.note,
  });

  factory Receipt.fromJson(Map<String, dynamic> j) => Receipt(
    id: j['id'],
    month: j['month'],
    status: j['status'],
    amount: (j['amount'] as num?)?.toDouble(),
    merchant: j['merchant'],
    date: j['date'] != null ? DateTime.parse(j['date']) : null,
    category: j['category'],
    note: j['note'],
  );
}
