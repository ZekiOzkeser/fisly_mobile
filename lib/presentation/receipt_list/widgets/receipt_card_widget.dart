import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Receipt Card Widget - Displays individual receipt information
///
/// Features:
/// - Supplier name and description
/// - Amount with currency formatting
/// - Date display
/// - Category icon with color coding
/// - Status indicator
/// - VAT badge
/// - Tap gesture handling
class ReceiptCardWidget extends StatelessWidget {
  final Map<String, dynamic> receipt;
  final VoidCallback onTap;

  const ReceiptCardWidget({
    super.key,
    required this.receipt,
    required this.onTap,
  });

  /// Get category icon based on category type
  String _getCategoryIcon(String category) {
    switch (category) {
      case 'food':
        return 'restaurant';
      case 'transport':
        return 'directions_car';
      case 'office':
        return 'business';
      default:
        return 'receipt';
    }
  }

  /// Get category color based on category type
  Color _getCategoryColor(String category, ColorScheme colorScheme) {
    switch (category) {
      case 'food':
        return Color(0xFFEF4444);
      case 'transport':
        return Color(0xFF3B82F6);
      case 'office':
        return Color(0xFF8B5CF6);
      default:
        return colorScheme.secondary;
    }
  }

  /// Get status color based on status type
  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status) {
      case 'approved':
        return Color(0xFF059669);
      case 'pending':
        return Color(0xFFD97706);
      case 'draft':
        return colorScheme.secondary;
      default:
        return colorScheme.secondary;
    }
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Bugün';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return DateFormat('dd MMM yyyy', 'tr_TR').format(date);
    }
  }

  /// Format amount with Turkish Lira formatting
  String _formatAmount(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'tr_TR',
      symbol: '₺',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final supplier = receipt['supplier'] as String;
    final description = receipt['description'] as String;
    final amount = receipt['amount'] as double;
    final date = receipt['date'] as DateTime;
    final category = receipt['category'] as String;
    final categoryName = receipt['categoryName'] as String;
    final status = receipt['status'] as String;
    final statusName = receipt['statusName'] as String;
    final hasVAT = receipt['hasVAT'] as bool;

    final categoryColor = _getCategoryColor(category, colorScheme);
    final statusColor = _getStatusColor(status, colorScheme);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Category icon
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: _getCategoryIcon(category),
                      color: categoryColor,
                      size: 24,
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Supplier and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplier,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 3.w),

                // Amount
                Text(
                  _formatAmount(amount),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Bottom row with date, category, status, and VAT badge
            Row(
              children: [
                // Date
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'calendar_today',
                      color: colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _formatDate(date),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 4.w),

                // Category
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    categoryName,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: categoryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                Spacer(),

                // VAT badge
                if (hasVAT)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'KDV',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                if (hasVAT) SizedBox(width: 2.w),

                // Status indicator
                Container(
                  width: 2.w,
                  height: 2.w,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 1.w),
                Text(
                  statusName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
