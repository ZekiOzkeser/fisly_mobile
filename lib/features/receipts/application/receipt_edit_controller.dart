import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../domain/receipt.dart';
import '../domain/receipt_category.dart';
import 'receipt_edit_state.dart';
import 'receipts_providers.dart';

final receiptEditControllerProvider =
    StateNotifierProvider.family<
      ReceiptEditController,
      ReceiptEditState,
      Receipt
    >((ref, receipt) {
      return ReceiptEditController(ref: ref, receipt: receipt);
    });

class ReceiptEditController extends StateNotifier<ReceiptEditState> {
  final Ref ref;
  final Receipt receipt;

  ReceiptEditController({required this.ref, required this.receipt})
    : super(
        ReceiptEditState(category: receipt.category, note: receipt.note ?? ''),
      );

  void setCategory(ReceiptCategory? c) {
    state = state.copyWith(category: c, error: null);
  }

  void setNote(String v) {
    state = state.copyWith(note: v, error: null);
  }

  Future<bool> save() async {
    state = state.copyWith(saving: true, error: null);
    try {
      await ref
          .read(receiptsRepositoryProvider)
          .update(
            id: receipt.id,
            category: state.category,
            note: state.note.trim(),
          );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    } finally {
      state = state.copyWith(saving: false);
    }
  }
}
