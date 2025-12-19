import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/network/dio_provider.dart';
import '../data/receipts_api.dart';
import '../domain/receipt.dart';

final receiptsApiProvider = Provider<ReceiptsApi>((ref) {
  return ReceiptsApi(ref.watch(dioProvider));
});

final selectedMonthProvider = StateProvider<String>((_) => _currentMonth());

String _currentMonth() {
  final now = DateTime.now();
  final m = now.month.toString().padLeft(2, '0');
  return '${now.year}-$m';
}

final receiptsControllerProvider =
    AsyncNotifierProvider<ReceiptsController, List<Receipt>>(
      ReceiptsController.new,
    );

class ReceiptsController extends AsyncNotifier<List<Receipt>> {
  @override
  Future<List<Receipt>> build() async {
    final month = ref.watch(selectedMonthProvider);
    return ref.read(receiptsApiProvider).listByMonth(month);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final month = ref.read(selectedMonthProvider);
      return ref.read(receiptsApiProvider).listByMonth(month);
    });
  }
}
