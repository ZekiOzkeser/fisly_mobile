import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/receipts_providers.dart';

final receiptDetailProvider = FutureProvider.family((ref, String id) {
  return ref.read(receiptsApiProvider).getOne(id);
});

class ReceiptDetailPage extends ConsumerWidget {
  final String id;
  const ReceiptDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(receiptDetailProvider(id));

    return Scaffold(
      appBar: AppBar(title: const Text('Fiş Detay')),
      body: async.when(
        data: (r) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                r.merchant ?? 'Belge',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text('Durum: ${r.status}'),
              const SizedBox(height: 8),
              Text('Tutar: ${r.amount?.toStringAsFixed(2) ?? "-"}'),
              const SizedBox(height: 8),
              Text('Kategori: ${r.category ?? "-"}'),
              const SizedBox(height: 8),
              Text('Not: ${r.note ?? "-"}'),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
      ),
    );
  }
}
