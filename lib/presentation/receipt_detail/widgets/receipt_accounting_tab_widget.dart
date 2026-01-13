import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Receipt Accounting Tab Widget
/// Displays financial and accounting information
class ReceiptAccountingTabWidget extends StatelessWidget {
  final Map<String, dynamic> receiptData;

  const ReceiptAccountingTabWidget({super.key, required this.receiptData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAccountCard(theme),
          SizedBox(height: 2.h),
          _buildVATCard(theme),
          SizedBox(height: 2.h),
          _buildApprovalCard(theme),
          SizedBox(height: 2.h),
          _buildIntegrationCard(theme),
        ],
      ),
    );
  }

  Widget _buildAccountCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hesap Bilgileri',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildInfoRow(
              theme,
              'Hesap',
              receiptData['account'] as String,
              Icons.account_balance,
            ),
            Divider(height: 3.h),
            _buildInfoRow(
              theme,
              'Kategori',
              receiptData['category'] as String,
              Icons.category,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVATCard(ThemeData theme) {
    final vatRate = receiptData['vatRate'] as double;
    final vatAmount = receiptData['vatAmount'] as double;
    final netAmount = receiptData['netAmount'] as double;
    final totalAmount = receiptData['amount'] as double;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'KDV Detayları',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildAmountRow(theme, 'Net Tutar', netAmount, false),
            SizedBox(height: 1.h),
            _buildAmountRow(
              theme,
              'KDV (%${vatRate.toStringAsFixed(0)})',
              vatAmount,
              false,
            ),
            Divider(height: 3.h),
            _buildAmountRow(theme, 'Toplam Tutar', totalAmount, true),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalCard(ThemeData theme) {
    final approvalStatus = receiptData['approvalStatus'] as String;
    final approvedBy = receiptData['approvedBy'] as String?;
    final approvalDate = receiptData['approvalDate'] as DateTime?;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Onay Durumu',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _getApprovalStatusColor(
                  approvalStatus,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: _getApprovalStatusIcon(approvalStatus),
                    color: _getApprovalStatusColor(approvalStatus),
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    _getApprovalStatusText(approvalStatus),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _getApprovalStatusColor(approvalStatus),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (approvalStatus == 'approved' && approvedBy != null) ...[
              SizedBox(height: 2.h),
              Divider(),
              SizedBox(height: 2.h),
              _buildInfoRow(theme, 'Onaylayan', approvedBy, Icons.person),
              if (approvalDate != null) ...[
                SizedBox(height: 1.h),
                _buildInfoRow(
                  theme,
                  'Onay Tarihi',
                  DateFormat('dd/MM/yyyy HH:mm').format(approvalDate),
                  Icons.calendar_today,
                ),
              ],
            ],
            if (approvalStatus == 'pending') ...[
              SizedBox(height: 2.h),
              Text(
                'Bu fiş onay bekliyor. Yetkili kişi tarafından onaylanması gerekmektedir.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationCard(ThemeData theme) {
    final syncStatus = receiptData['syncStatus'] as String;
    final integrationSystem = receiptData['integrationSystem'] as String?;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Entegrasyon',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _getSyncStatusColor(syncStatus).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: _getSyncStatusIcon(syncStatus),
                    color: _getSyncStatusColor(syncStatus),
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    _getSyncStatusText(syncStatus),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _getSyncStatusColor(syncStatus),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (integrationSystem != null) ...[
              SizedBox(height: 2.h),
              Divider(),
              SizedBox(height: 2.h),
              _buildInfoRow(
                theme,
                'Muhasebe Sistemi',
                integrationSystem,
                Icons.integration_instructions,
              ),
            ],
            if (syncStatus == 'synced') ...[
              SizedBox(height: 2.h),
              Text(
                'Bu fiş muhasebe sistemine başarıyla aktarılmıştır.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (syncStatus == 'pending') ...[
              SizedBox(height: 2.h),
              Text(
                'Bu fiş muhasebe sistemine aktarılmayı bekliyor.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (syncStatus == 'failed') ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Color(0xFFDC2626).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Color(0xFFDC2626).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'error_outline',
                      color: Color(0xFFDC2626),
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Aktarım sırasında bir hata oluştu. Lütfen tekrar deneyin.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon
              .toString()
              .split('.')
              .last
              .replaceAll('IconData(U+', '')
              .replaceAll(')', ''),
          color: theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountRow(
    ThemeData theme,
    String label,
    double amount,
    bool isTotal,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )
              : theme.textTheme.bodyMedium,
        ),
        Text(
          '₺ ${amount.toStringAsFixed(2)}',
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
        ),
      ],
    );
  }

  Color _getApprovalStatusColor(String status) {
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

  String _getApprovalStatusIcon(String status) {
    switch (status) {
      case 'approved':
        return 'check_circle';
      case 'pending':
        return 'schedule';
      case 'rejected':
        return 'cancel';
      default:
        return 'help_outline';
    }
  }

  String _getApprovalStatusText(String status) {
    switch (status) {
      case 'approved':
        return 'Onaylandı';
      case 'pending':
        return 'Onay Bekliyor';
      case 'rejected':
        return 'Reddedildi';
      default:
        return 'Bilinmiyor';
    }
  }

  Color _getSyncStatusColor(String status) {
    switch (status) {
      case 'synced':
        return Color(0xFF059669);
      case 'pending':
        return Color(0xFFD97706);
      case 'failed':
        return Color(0xFFDC2626);
      default:
        return Color(0xFF64748B);
    }
  }

  String _getSyncStatusIcon(String status) {
    switch (status) {
      case 'synced':
        return 'cloud_done';
      case 'pending':
        return 'cloud_queue';
      case 'failed':
        return 'cloud_off';
      default:
        return 'cloud';
    }
  }

  String _getSyncStatusText(String status) {
    switch (status) {
      case 'synced':
        return 'Senkronize Edildi';
      case 'pending':
        return 'Senkronizasyon Bekliyor';
      case 'failed':
        return 'Senkronizasyon Başarısız';
      default:
        return 'Bilinmiyor';
    }
  }
}
