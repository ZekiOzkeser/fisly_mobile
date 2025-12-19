import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/fake_receipts_repository.dart';
import '../data/receipts_repository.dart';

final receiptsRepositoryProvider = Provider<ReceiptsRepository>((ref) {
  // Backend gelince burayı ApiReceiptsRepository ile değiştir
  return FakeReceiptsRepository();
});

final selectedMonthProvider = StateProvider<String>((_) => _currentMonth());

String _currentMonth() {
  final now = DateTime.now();
  final mm = now.month.toString().padLeft(2, '0');
  return '${now.year}-$mm';
}
