import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Filter Chip Widget - Displays filter chips with optional count badge
///
/// Features:
/// - Active/inactive states
/// - Optional icon
/// - Count badge
/// - Remove action
/// - Tap gesture handling
class FilterChipWidget extends StatelessWidget {
  final String label;
  final String? icon;
  final int? count;
  final bool isActive;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const FilterChipWidget({
    super.key,
    required this.label,
    this.icon,
    this.count,
    this.isActive = false,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            if (icon != null) ...[
              CustomIconWidget(
                iconName: icon!,
                color: isActive
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
                size: 18,
              ),
              SizedBox(width: 1.w),
            ],

            // Label
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isActive
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),

            // Count badge
            if (count != null && count! > 0) ...[
              SizedBox(width: 1.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 1.5.w,
                  vertical: 0.3.h,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isActive
                        ? colorScheme.onPrimary
                        : colorScheme.surface,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],

            // Remove button
            if (isActive && onRemove != null) ...[
              SizedBox(width: 1.w),
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: EdgeInsets.all(0.5.w),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onPrimaryContainer,
                    size: 16,
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
