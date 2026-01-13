import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Preview screen widget for captured image
/// Shows image with crop and process options
class PreviewScreenWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onRetake;
  final VoidCallback onCrop;
  final VoidCallback onProcess;

  const PreviewScreenWidget({
    super.key,
    required this.imagePath,
    required this.onRetake,
    required this.onCrop,
    required this.onProcess,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: theme.colorScheme.surface),
            child: Row(
              children: [
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: theme.colorScheme.onSurface,
                    size: 24,
                  ),
                  onPressed: onRetake,
                  tooltip: 'Back',
                ),
                SizedBox(width: 8),
                Text('Preview', style: theme.textTheme.titleLarge),
              ],
            ),
          ),

          // Image preview
          Expanded(
            child: Center(
              child: imagePath.isNotEmpty
                  ? Image.file(File(imagePath), fit: BoxFit.contain)
                  : Container(
                      color: Colors.grey[900],
                      child: Center(
                        child: Text(
                          'No image',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Crop button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onCrop,
                    icon: CustomIconWidget(
                      iconName: 'crop',
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    label: Text('Adjust Frame'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                // Action buttons row
                Row(
                  children: [
                    // Retake button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onRetake,
                        icon: CustomIconWidget(
                          iconName: 'refresh',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        label: Text('Retake'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),

                    SizedBox(width: 12),

                    // Process button
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: onProcess,
                        icon: CustomIconWidget(
                          iconName: 'check_circle',
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text('Process'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
