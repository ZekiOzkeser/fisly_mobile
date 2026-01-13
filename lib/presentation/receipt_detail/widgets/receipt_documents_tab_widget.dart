import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Receipt Documents Tab Widget
/// Displays receipt images in gallery format with zoom and management
class ReceiptDocumentsTabWidget extends StatefulWidget {
  final List<Map<String, dynamic>> documents;
  final Function(Map<String, dynamic>) onDocumentAdded;
  final Function(int) onDocumentDeleted;

  const ReceiptDocumentsTabWidget({
    super.key,
    required this.documents,
    required this.onDocumentAdded,
    required this.onDocumentDeleted,
  });

  @override
  State<ReceiptDocumentsTabWidget> createState() =>
      _ReceiptDocumentsTabWidgetState();
}

class _ReceiptDocumentsTabWidgetState extends State<ReceiptDocumentsTabWidget> {
  void _viewDocument(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _DocumentViewerScreen(
          documents: widget.documents,
          initialIndex: index,
          onDelete: (docIndex) {
            widget.onDocumentDeleted(docIndex);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _addDocument() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Belge Ekle', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('Fotoğraf Çek'),
              onTap: () {
                Navigator.pop(context);
                _capturePhoto();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('Galeriden Seç'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'insert_drive_file',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('Dosya Seç'),
              onTap: () {
                Navigator.pop(context);
                _pickFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _capturePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kamera özelliği yakında eklenecek')),
    );
  }

  void _pickFromGallery() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Galeri özelliği yakında eklenecek')),
    );
  }

  void _pickFile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dosya seçme özelliği yakında eklenecek')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return widget.documents.isEmpty
        ? _buildEmptyState(theme)
        : Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(4.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3.w,
                    mainAxisSpacing: 2.h,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: widget.documents.length,
                  itemBuilder: (context, index) {
                    return _buildDocumentCard(theme, index);
                  },
                ),
              ),
              _buildAddButton(theme),
            ],
          );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'insert_drive_file',
            color: theme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Henüz belge eklenmemiş',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Fiş belgelerini eklemek için\naşağıdaki butona tıklayın',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton.icon(
            onPressed: _addDocument,
            icon: CustomIconWidget(
              iconName: 'add',
              color: Colors.white,
              size: 20,
            ),
            label: Text('Belge Ekle'),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(ThemeData theme, int index) {
    final document = widget.documents[index];

    return GestureDetector(
      onTap: () => _viewDocument(index),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomImageWidget(
                    imageUrl: document['url'] as String,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    semanticLabel: document['semanticLabel'] as String,
                  ),
                  Positioned(
                    top: 2.w,
                    right: 2.w,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: CustomIconWidget(
                        iconName: 'zoom_in',
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getDocumentTypeLabel(document['type'] as String),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    DateFormat(
                      'dd/MM/yyyy',
                    ).format(document['uploadDate'] as DateTime),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton.icon(
          onPressed: _addDocument,
          icon: CustomIconWidget(
            iconName: 'add',
            color: Colors.white,
            size: 20,
          ),
          label: Text('Belge Ekle'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 6.h),
          ),
        ),
      ),
    );
  }

  String _getDocumentTypeLabel(String type) {
    switch (type) {
      case 'receipt':
        return 'Fiş';
      case 'invoice':
        return 'Fatura';
      case 'other':
        return 'Diğer';
      default:
        return 'Belge';
    }
  }
}

class _DocumentViewerScreen extends StatefulWidget {
  final List<Map<String, dynamic>> documents;
  final int initialIndex;
  final Function(int) onDelete;

  const _DocumentViewerScreen({
    required this.documents,
    required this.initialIndex,
    required this.onDelete,
  });

  @override
  State<_DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<_DocumentViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  double _rotation = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _rotateImage() {
    setState(() {
      _rotation += 90;
      if (_rotation >= 360) _rotation = 0;
    });
  }

  void _deleteDocument() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Belgeyi Sil'),
        content: Text('Bu belgeyi silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete(_currentIndex);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFDC2626)),
            child: Text('Sil'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'close',
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_currentIndex + 1} / ${widget.documents.length}',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'rotate_right',
              color: Colors.white,
              size: 24,
            ),
            onPressed: _rotateImage,
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'delete',
              color: Colors.white,
              size: 24,
            ),
            onPressed: _deleteDocument,
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.documents.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
            _rotation = 0;
          });
        },
        itemBuilder: (context, index) {
          final document = widget.documents[index];
          return InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Transform.rotate(
                angle: _rotation * 3.14159 / 180,
                child: CustomImageWidget(
                  imageUrl: document['url'] as String,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                  semanticLabel: document['semanticLabel'] as String,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
