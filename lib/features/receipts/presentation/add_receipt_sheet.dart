import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../application/receipts_list_controller.dart';
import '../application/receipts_providers.dart';

class AddReceiptSheet extends ConsumerWidget {
  const AddReceiptSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    final repo = ref.read(receiptsRepositoryProvider);
    final picker = ImagePicker();

    Future<void> done() async {
      // ignore: unused_result
      await ref.read(receiptsListControllerProvider.notifier).refresh();
      if (context.mounted) Navigator.pop(context);
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Fiş Ekle',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Kamera ile çek'),
              onTap: () async {
                final img = await picker.pickImage(source: ImageSource.camera);
                if (img == null) return;
                await repo.upload(month: month, image: img);
                await done();
              },
            ),

            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeriden seç'),
              onTap: () async {
                final img = await picker.pickImage(source: ImageSource.gallery);
                if (img == null) return;
                await repo.upload(month: month, image: img);
                await done();
              },
            ),

            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('PDF yükle'),
              onTap: () async {
                final res = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );
                final path = res?.files.single.path;
                if (path == null) return;
                await repo.upload(month: month, pdfPath: path);
                await done();
              },
            ),

            const SizedBox(height: 8),
            Text(
              'Seçilen ay: $month',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
