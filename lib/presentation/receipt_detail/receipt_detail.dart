import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../services/api_client.dart';
import '../../services/receipt_service.dart';
import '../../models/receipt_models.dart';
import './widgets/receipt_accounting_tab_widget.dart';
import './widgets/receipt_details_tab_widget.dart';
import './widgets/receipt_documents_tab_widget.dart';

/// Receipt Detail Screen
/// Provides comprehensive receipt information through tabbed interface
/// Supports edit mode, document management, and accounting details
class ReceiptDetail extends StatefulWidget {
  const ReceiptDetail({super.key});

  @override
  State<ReceiptDetail> createState() => _ReceiptDetailState();
}

class _ReceiptDetailState extends State<ReceiptDetail>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditMode = false;
  bool _isSyncing = false;
  bool _isLoading = false;

  late final ApiClient _apiClient;
  late final ReceiptService _receiptService;
  String? _receiptParsedId;

  // Mock receipt data
  final Map<String, dynamic> _receiptData = {
    "id": "RCP-2026-001",
    "supplier": "Teknoloji Mağazası A.Ş.",
    "amount": 2450.00,
    "currency": "TRY",
    "date": DateTime(2026, 1, 10),
    "category": "Teknoloji",
    "categoryIcon": "computer",
    "categoryColor": 0xFF3B82F6,
    "description": "Laptop ve aksesuar alımı",
    "tags": ["Teknoloji", "Ofis", "Ekipman"],
    "status": "approved",
    "account": "İş Bankası Hesabı",
    "vatRate": 20.0,
    "vatAmount": 408.33,
    "netAmount": 2041.67,
    "approvalStatus": "approved",
    "approvedBy": "Ahmet Yılmaz",
    "approvalDate": DateTime(2026, 1, 11),
    "syncStatus": "synced",
    "integrationSystem": "Logo",
    "documents": [
      {
        "url":
            "https://img.rocket.new/generatedImages/rocket_gen_img_16c66c8bf-1767346835472.png",
        "semanticLabel":
            "Receipt document showing itemized purchase details with store logo and payment information on white paper",
        "type": "receipt",
        "uploadDate": DateTime(2026, 1, 10),
      },
      {
        "url":
            "https://img.rocket.new/generatedImages/rocket_gen_img_1eab71d13-1767337699816.png",
        "semanticLabel":
            "Product invoice with company letterhead, line items, and total amount highlighted in blue",
        "type": "invoice",
        "uploadDate": DateTime(2026, 1, 10),
      },
    ],
    "notes": "Şirket bilgisayarı için yapılan alım",
    "createdBy": "Mehmet Demir",
    "createdDate": DateTime(2026, 1, 10),
    "lastModified": DateTime(2026, 1, 12),
  };

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _receiptService = ReceiptService(_apiClient);
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReceiptDetail();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadReceiptDetail() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _receiptParsedId = args;
      await _fetchReceiptDetail();
    } else if (args is Map<String, dynamic>) {
      _receiptData.addAll(args);
    }
  }

  Future<void> _fetchReceiptDetail() async {
    if (_receiptParsedId == null) return;
    setState(() => _isLoading = true);

    try {
      final detail = await _receiptService.getParsedDetail(_receiptParsedId!);
      if (mounted) {
        setState(() {
          _receiptData['id'] = detail.receiptId;
          _receiptData['supplier'] = detail.companyName;
          _receiptData['amount'] = detail.grandTotal ?? detail.subTotal ?? 0.0;
          _receiptData['date'] = detail.date != null
              ? DateTime.tryParse(detail.date!) ?? _receiptData['date']
              : _receiptData['date'];
          _receiptData['status'] = _mapDetailStatus(detail.status);
          _receiptData['vatAmount'] =
              detail.vatTotal ?? _receiptData['vatAmount'];
          _receiptData['netAmount'] = detail.subTotal ?? _receiptData['netAmount'];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _mapDetailStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'processed':
      case 'done':
        return 'approved';
      case 'manual_review':
      case 'manualreview':
        return 'pending';
      case 'failed':
        return 'draft';
      case 'parsed':
        return 'pending';
      default:
        return 'pending';
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _saveChanges() {
    setState(() {
      _isEditMode = false;
      _isSyncing = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Değişiklikler kaydedildi'),
            backgroundColor: Color(0xFF059669),
          ),
        );
      }
    });
  }

  void _submitForApproval() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Onaya Gönder'),
        content: Text('Bu fişi onaya göndermek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Fiş onaya gönderildi'),
                  backgroundColor: Color(0xFF059669),
                ),
              );
            },
            child: Text('Gönder'),
          ),
        ],
      ),
    );
  }

  void _approveReceipt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Fişi Onayla'),
        content: Text('Bu fişi onaylamak istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _receiptData['approvalStatus'] = 'approved';
                _receiptData['status'] = 'approved';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Fiş onaylandı'),
                  backgroundColor: Color(0xFF059669),
                ),
              );
            },
            child: Text('Onayla'),
          ),
        ],
      ),
    );
  }

  void _rejectReceipt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Fişi Reddet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ret nedeni:'),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                hintText: 'Ret nedenini giriniz',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _receiptData['approvalStatus'] = 'rejected';
                _receiptData['status'] = 'rejected';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Fiş reddedildi'),
                  backgroundColor: Color(0xFFDC2626),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFDC2626)),
            child: Text('Reddet'),
          ),
        ],
      ),
    );
  }

  void _exportReceipt() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Dışa Aktar', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'picture_as_pdf',
                color: Color(0xFFDC2626),
                size: 24,
              ),
              title: Text('PDF olarak dışa aktar'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('PDF oluşturuluyor...')));
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'table_chart',
                color: Color(0xFF059669),
                size: 24,
              ),
              title: Text('Excel olarak dışa aktar'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Excel oluşturuluyor...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareReceipt() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Paylaşım özelliği yakında eklenecek')),
    );
  }

  void _deleteReceipt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Fişi Sil'),
        content: Text(
          'Bu fişi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushReplacementNamed('/receipt-list');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Fiş silindi'),
                  backgroundColor: Color(0xFFDC2626),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFDC2626)),
            child: Text('Sil'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Color(0xFF059669);
      case 'pending':
        return Color(0xFFD97706);
      case 'rejected':
        return Color(0xFFDC2626);
      default:
        return Color(0xFF64748B);
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'approved':
        return 'Onaylandı';
      case 'pending':
        return 'Beklemede';
      case 'rejected':
        return 'Reddedildi';
      default:
        return 'Taslak';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _receiptData['supplier'] as String,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _receiptData['id'] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          if (_isSyncing)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: CustomIconWidget(
                iconName: _isEditMode ? 'check' : 'edit',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              onPressed: _isEditMode ? _saveChanges : _toggleEditMode,
            ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(6.h),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                indicatorColor: theme.colorScheme.primary,
                tabs: [
                  Tab(text: 'Detaylar'),
                  Tab(text: 'Belgeler'),
                  Tab(text: 'Muhasebe'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ReceiptDetailsTabWidget(
                  receiptData: _receiptData,
                  isEditMode: _isEditMode,
                  onDataChanged: (key, value) {
                    setState(() {
                      _receiptData[key] = value;
                    });
                  },
                ),
                ReceiptDocumentsTabWidget(
                  documents: (_receiptData['documents'] as List)
                      .cast<Map<String, dynamic>>(),
                  onDocumentAdded: (document) {
                    setState(() {
                      (_receiptData['documents'] as List).add(document);
                    });
                  },
                  onDocumentDeleted: (index) {
                    setState(() {
                      (_receiptData['documents'] as List).removeAt(index);
                    });
                  },
                ),
                ReceiptAccountingTabWidget(receiptData: _receiptData),
              ],
            ),
          ),
          _buildBottomActionBar(theme),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(ThemeData theme) {
    final status = _receiptData['status'] as String;
    final approvalStatus = _receiptData['approvalStatus'] as String;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: status == 'approved'
                        ? 'check_circle'
                        : status == 'pending'
                        ? 'schedule'
                        : status == 'rejected'
                        ? 'cancel'
                        : 'edit',
                    color: _getStatusColor(status),
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    _getStatusText(status),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                if (status == 'draft' || status == 'rejected')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submitForApproval,
                      icon: CustomIconWidget(
                        iconName: 'send',
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text('Onaya Gönder'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                    ),
                  ),
                if (status == 'pending' && approvalStatus == 'pending') ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _approveReceipt,
                      icon: CustomIconWidget(
                        iconName: 'check',
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text('Onayla'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF059669),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _rejectReceipt,
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: Color(0xFFDC2626),
                        size: 20,
                      ),
                      label: Text('Reddet'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFFDC2626),
                        side: BorderSide(color: Color(0xFFDC2626)),
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                    ),
                  ),
                ],
                if (status == 'approved') ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _exportReceipt,
                      icon: CustomIconWidget(
                        iconName: 'file_download',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      label: Text('Dışa Aktar'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _shareReceipt,
                      icon: CustomIconWidget(
                        iconName: 'share',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      label: Text('Paylaş'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 1.h),
            TextButton.icon(
              onPressed: _deleteReceipt,
              icon: CustomIconWidget(
                iconName: 'delete',
                color: Color(0xFFDC2626),
                size: 20,
              ),
              label: Text('Fişi Sil'),
              style: TextButton.styleFrom(foregroundColor: Color(0xFFDC2626)),
            ),
          ],
        ),
      ),
    );
  }
}
