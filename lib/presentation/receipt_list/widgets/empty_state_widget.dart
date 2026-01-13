import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Empty State Widget - Displays empty state with appropriate messaging
///
/// Features:
/// - Different states for no receipts vs no results
/// - Illustration
/// - Action buttons
/// - Helpful messaging
class EmptyStateWidget extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback? onClearFilters;
  final VoidCallback? onAddReceipt;

  const EmptyStateWidget({
    super.key,
    this.hasFilters = false,
    this.onClearFilters,
    this.onAddReceipt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: hasFilters ? 'search_off' : 'receipt_long',
                  color: colorScheme.primary,
                  size: 80,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              hasFilters ? 'Sonuç Bulunamadı' : 'Henüz Fiş Yok',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              hasFilters
                  ? 'Arama kriterlerinize uygun fiş bulunamadı. Filtreleri temizleyip tekrar deneyin.'
                  : 'İlk fişinizi ekleyerek harcamalarınızı takip etmeye başlayın.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action buttons
            if (hasFilters && onClearFilters != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onClearFilters,
                  icon: CustomIconWidget(
                    iconName: 'filter_list_off',
                    color: colorScheme.onPrimary,
                    size: 20,
                  ),
                  label: Text('Filtreleri Temizle'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              )
            else if (onAddReceipt != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onAddReceipt,
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: colorScheme.onPrimary,
                    size: 20,
                  ),
                  label: Text('İlk Fişi Ekle'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),

            if (hasFilters && onAddReceipt != null) ...[
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onAddReceipt,
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  label: Text('Yeni Fiş Ekle'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
