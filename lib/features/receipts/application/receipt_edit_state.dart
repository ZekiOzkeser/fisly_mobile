import '../domain/receipt_category.dart';

class ReceiptEditState {
  final ReceiptCategory? category;
  final String note;
  final bool saving;
  final String? error;

  const ReceiptEditState({
    required this.category,
    required this.note,
    this.saving = false,
    this.error,
  });

  ReceiptEditState copyWith({
    ReceiptCategory? category,
    String? note,
    bool? saving,
    String? error,
  }) {
    return ReceiptEditState(
      category: category ?? this.category,
      note: note ?? this.note,
      saving: saving ?? this.saving,
      error: error,
    );
  }
}
