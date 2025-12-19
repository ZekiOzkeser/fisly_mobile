// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../application/receipts_providers.dart';
// import 'add_receipt_sheet.dart';
// import 'receipt_detail_page.dart';

// class ReceiptsPage extends ConsumerWidget {
//   const ReceiptsPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final month = ref.watch(selectedMonthProvider);
//     final receiptsAsync = ref.watch(receiptsControllerProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Fişler • $month'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () =>
//                 ref.read(receiptsControllerProvider.notifier).refresh(),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             builder: (_) => const AddReceiptSheet(),
//           );
//           // upload sonrası listeyi tazele
//           ref.read(receiptsControllerProvider.notifier).refresh();
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: receiptsAsync.when(
//         data: (items) => ListView.separated(
//           itemCount: items.length,
//           separatorBuilder: (_, __) => const Divider(height: 1),
//           itemBuilder: (_, i) {
//             final r = items[i];
//             return ListTile(
//               title: Text(r.merchant ?? 'Belge'),
//               subtitle: Text('Durum: ${r.status}'),
//               trailing: r.amount != null
//                   ? Text(r.amount!.toStringAsFixed(2))
//                   : null,
//               onTap: () => Navigator.of(context).push(
//                 MaterialPageRoute(builder: (_) => ReceiptDetailPage(id: r.id)),
//               ),
//             );
//           },
//         ),
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, _) => Center(child: Text('Hata: $e')),
//       ),
//     );
//   }
// }
import 'package:fisly_mobile/features/receipts/presentation/add_receipt_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/auth_providers.dart';
import '../application/receipts_list_controller.dart';
import '../application/receipts_providers.dart';

import 'receipt_detail_page.dart';

class ReceiptsPage extends ConsumerWidget {
  const ReceiptsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final receiptsAsync = ref.watch(receiptsListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fisly'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                builder: (_) => const AddReceiptSheet(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          _MonthChips(
            selected: selectedMonth,
            onSelected: (m) {
              ref.read(selectedMonthProvider.notifier).state = m;
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: receiptsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Center(child: Text('Bu ay için fiş yok.'));
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final r = items[i];
                    return ListTile(
                      title: Text(r.merchant ?? 'Belge'),
                      subtitle: Text('${r.status} • ${r.month}'),
                      trailing: r.amount != null
                          ? Text(r.amount!.toStringAsFixed(2))
                          : null,
                      onTap: () async {
                        final changed = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) => ReceiptDetailPage(id: r.id),
                          ),
                        );

                        if (changed == true) {
                          // listeyi tazele
                          // ignore: unused_result
                          ref
                              .read(receiptsListControllerProvider.notifier)
                              .refresh();
                        }
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Hata: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _MonthChips({required this.selected, required this.onSelected});

  List<String> _months() {
    final now = DateTime.now();
    final list = <String>[];
    // Son 6 ay + bu ay
    for (int i = 5; i >= 0; i--) {
      final d = DateTime(now.year, now.month - i, 1);
      list.add('${d.year}-${d.month.toString().padLeft(2, '0')}');
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final months = _months();

    return SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final m = months[i];
          final isSelected = m == selected;
          return ChoiceChip(
            label: Text(m),
            selected: isSelected,
            onSelected: (_) => onSelected(m),
          );
        },
      ),
    );
  }
}
