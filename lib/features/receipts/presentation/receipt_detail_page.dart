import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/receipt_edit_controller.dart';
import '../application/receipts_providers.dart';
import '../domain/receipt.dart';
import '../domain/receipt_category.dart';

final receiptDetailProvider = FutureProvider.family<Receipt, String>((
  ref,
  id,
) async {
  return ref.read(receiptsRepositoryProvider).getById(id);
});

class ReceiptDetailPage extends ConsumerStatefulWidget {
  final String id;
  const ReceiptDetailPage({super.key, required this.id});

  @override
  ConsumerState<ReceiptDetailPage> createState() => _ReceiptDetailPageState();
}

class _ReceiptDetailPageState extends ConsumerState<ReceiptDetailPage> {
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(receiptDetailProvider(widget.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Fiş Detay')),
      body: async.when(
        data: (r) {
          final edit = ref.watch(receiptEditControllerProvider(r));
          final controller = ref.read(
            receiptEditControllerProvider(r).notifier,
          );

          // controller'ı her build'de resetlememek için:
          if (_noteCtrl.text != edit.note) {
            _noteCtrl.text = edit.note;
            _noteCtrl.selection = TextSelection.collapsed(
              offset: _noteCtrl.text.length,
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.merchant ?? 'Belge',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text('Ay: ${r.month}'),
                const SizedBox(height: 12),

                // Kategori
                DropdownButtonFormField<ReceiptCategory>(
                  value: edit.category,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items: ReceiptCategory.values
                      .map(
                        (c) => DropdownMenuItem(value: c, child: Text(c.label)),
                      )
                      .toList(),
                  onChanged: edit.saving ? null : controller.setCategory,
                ),
                const SizedBox(height: 12),

                // Açıklama
                TextField(
                  controller: _noteCtrl,
                  enabled: !edit.saving,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Açıklama',
                    hintText: 'Örn: Müşteri yemeği',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: controller.setNote,
                ),

                if (edit.error != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Hata: ${edit.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: edit.saving
                        ? null
                        : () async {
                            final ok = await controller.save();
                            if (!mounted) return;
                            if (ok) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Kaydedildi ✅')),
                              );
                              Navigator.pop(
                                context,
                                true,
                              ); // Listeye "refresh" sinyali
                            }
                          },
                    child: edit.saving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Kaydet'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
      ),
    );
  }
}
