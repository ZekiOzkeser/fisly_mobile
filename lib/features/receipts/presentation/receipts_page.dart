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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/auth_providers.dart';

class ReceiptsPage extends ConsumerWidget {
  const ReceiptsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fisly'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: const Center(child: Text('ReceiptsPage (placeholder)')),
    );
  }
}
