import 'receipt_category.dart';
import 'receipt_status.dart';

class Receipt {
  final String id;
  final String month; // YYYY-MM
  final ReceiptStatus status;
  final double? amount;
  final String? merchant;
  final DateTime? date;
  final ReceiptCategory? category;
  final String? note;

  const Receipt({
    required this.id,
    required this.month,
    required this.status,
    this.amount,
    this.merchant,
    this.date,
    this.category,
    this.note,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'] as String,
      month: json['month'] as String,
      status: ReceiptStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => ReceiptStatus.ai, // Varsayılan değer
      ),
      amount: json['amount'] != null
          ? (json['amount'] as num).toDouble()
          : null,
      merchant: json['merchant'] as String?,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : null,
      category: json['category'] != null
          ? ReceiptCategory.values.firstWhere(
              (e) => e.toString().split('.').last == json['category'],
              orElse: () => ReceiptCategory.other, // Varsayılan değer
            )
          : null,
      note: json['note'] as String?,
    );
  }

  Receipt copyWith({
    ReceiptStatus? status,
    double? amount,
    String? merchant,
    DateTime? date,
    ReceiptCategory? category,
    String? note,
  }) {
    return Receipt(
      id: id,
      month: month,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      merchant: merchant ?? this.merchant,
      date: date ?? this.date,
      category: category ?? this.category,
      note: note ?? this.note,
    );
  }
}
