import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/receipt.dart';
import 'receipts_providers.dart';

final receiptsListControllerProvider =
    AsyncNotifierProvider<ReceiptsListController, List<Receipt>>(
      ReceiptsListController.new,
    );

class ReceiptsListController extends AsyncNotifier<List<Receipt>> {
  @override
  Future<List<Receipt>> build() async {
    final month = ref.watch(selectedMonthProvider);
    return ref.read(receiptsRepositoryProvider).listByMonth(month);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final month = ref.read(selectedMonthProvider);
      return ref.read(receiptsRepositoryProvider).listByMonth(month);
    });
  }
}
