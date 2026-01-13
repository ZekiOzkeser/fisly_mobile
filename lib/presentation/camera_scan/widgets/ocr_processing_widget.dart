import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// OCR processing widget with progress indicator
/// Shows loading state during receipt processing
class OCRProcessingWidget extends StatelessWidget {
  final double progress;

  const OCRProcessingWidget({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      color: theme.colorScheme.surface,
      child: Center(
        child: Container(
          width: size.width * 0.8,
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Processing icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'document_scanner',
                    color: theme.colorScheme.primary,
                    size: 40,
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Title
              Text(
                'Processing Receipt',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8),

              // Description
              Text(
                'Extracting information from your receipt...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 32),

              // Progress indicator
              Column(
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.2,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),

                  SizedBox(height: 12),

                  Text(
                    '${(progress * 100).toInt()}%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Processing steps
              _buildProcessingStep(
                theme: theme,
                icon: 'image',
                label: 'Analyzing image',
                isActive: progress < 0.3,
                isComplete: progress >= 0.3,
              ),

              SizedBox(height: 12),

              _buildProcessingStep(
                theme: theme,
                icon: 'text_fields',
                label: 'Extracting text',
                isActive: progress >= 0.3 && progress < 0.6,
                isComplete: progress >= 0.6,
              ),

              SizedBox(height: 12),

              _buildProcessingStep(
                theme: theme,
                icon: 'category',
                label: 'Identifying fields',
                isActive: progress >= 0.6 && progress < 0.9,
                isComplete: progress >= 0.9,
              ),

              SizedBox(height: 12),

              _buildProcessingStep(
                theme: theme,
                icon: 'check_circle',
                label: 'Finalizing',
                isActive: progress >= 0.9,
                isComplete: progress >= 1.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build processing step indicator
  Widget _buildProcessingStep({
    required ThemeData theme,
    required String icon,
    required String label,
    required bool isActive,
    required bool isComplete,
  }) {
    Color iconColor;
    Color textColor;

    if (isComplete) {
      iconColor = Color(0xFF059669);
      textColor = theme.colorScheme.onSurface;
    } else if (isActive) {
      iconColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.onSurface;
    } else {
      iconColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4);
      textColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
    }

    return Row(
      children: [
        CustomIconWidget(
          iconName: isComplete ? 'check_circle' : icon,
          color: iconColor,
          size: 20,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
        if (isActive && !isComplete)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
            ),
          ),
      ],
    );
  }
}
