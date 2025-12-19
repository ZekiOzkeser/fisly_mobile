import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../application/receipts_providers.dart';

class AddReceiptSheet extends ConsumerStatefulWidget {
  const AddReceiptSheet({super.key});

  @override
  ConsumerState<AddReceiptSheet> createState() => _AddReceiptSheetState();
}

class _AddReceiptSheetState extends ConsumerState<AddReceiptSheet> {
  bool _busy = false;

  Future<void> _upload(File file) async {
    setState(() => _busy = true);
    try {
      final month = ref.read(selectedMonthProvider);
      await ref.read(receiptsApiProvider).uploadFile(file: file, month: month);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Fiş Ekle',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          if (_busy) const LinearProgressIndicator(),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Kamera ile çek'),
            onTap: _busy
                ? null
                : () async {
                    final x = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 85,
                    );
                    if (x != null) await _upload(File(x.path));
                  },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Galeriden seç'),
            onTap: _busy
                ? null
                : () async {
                    final x = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 85,
                    );
                    if (x != null) await _upload(File(x.path));
                  },
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text('PDF/Dosya seç'),
            onTap: _busy
                ? null
                : () async {
                    final res = await FilePicker.platform.pickFiles(
                      type: FileType.any,
                    );
                    final path = res?.files.single.path;
                    if (path != null) await _upload(File(path));
                  },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
