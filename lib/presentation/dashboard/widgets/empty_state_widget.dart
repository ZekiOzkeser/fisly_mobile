import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onAddReceipt;

  const EmptyStateWidget({super.key, required this.onAddReceipt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageWidget(
              imageUrl:
                  'https://images.unsplash.com/photo-1554224311-beee460c201f?w=400&h=400&fit=crop',
              width: 60.w,
              height: 30.h,
              fit: BoxFit.contain,
              semanticLabel:
                  'Empty receipt box illustration with floating documents and checkmarks on light background',
            ),
            SizedBox(height: 4.h),
            Text(
              'Henüz Fiş Yok',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'İlk fişinizi ekleyerek finansal takibinize başlayın. Fiş eklemek için aşağıdaki butona tıklayın.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: onAddReceipt,
              icon: CustomIconWidget(
                iconName: 'add_circle_outline',
                color: Colors.white,
                size: 20,
              ),
              label: Text('İlk Fişi Ekle'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
