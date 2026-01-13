import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Extraction results widget showing OCR data
/// Displays confidence-highlighted fields with edit options
class ExtractionResultsWidget extends StatelessWidget {
  final Map<String, dynamic> results;
  final Function(String) onEdit;
  final VoidCallback onSave;
  final VoidCallback onRetake;

  const ExtractionResultsWidget({
    super.key,
    required this.results,
    required this.onEdit,
    required this.onSave,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Extraction Results',
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(
                        'Review and edit extracted data',
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

          // Results list
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                // Success message
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF059669).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFF059669).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: Color(0xFF059669),
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Receipt processed successfully',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Color(0xFF059669),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // Amount field
                _buildResultField(
                  theme: theme,
                  label: 'Amount',
                  value: results['amount']?['value'] ?? '',
                  confidence: results['amount']?['confidence'] ?? 0.0,
                  fieldName: 'amount',
                  icon: 'payments',
                ),

                SizedBox(height: 16),

                // Supplier field
                _buildResultField(
                  theme: theme,
                  label: 'Supplier',
                  value: results['supplier']?['value'] ?? '',
                  confidence: results['supplier']?['confidence'] ?? 0.0,
                  fieldName: 'supplier',
                  icon: 'store',
                ),

                SizedBox(height: 16),

                // Date field
                _buildResultField(
                  theme: theme,
                  label: 'Date',
                  value: results['date']?['value'] ?? '',
                  confidence: results['date']?['confidence'] ?? 0.0,
                  fieldName: 'date',
                  icon: 'calendar_today',
                ),

                SizedBox(height: 16),

                // Category field with suggestions
                _buildCategoryField(
                  theme: theme,
                  value: results['category']?['value'] ?? '',
                  confidence: results['category']?['confidence'] ?? 0.0,
                  suggestions:
                      (results['category']?['suggestions'] as List?)
                          ?.cast<String>() ??
                      [],
                ),

                SizedBox(height: 24),

                // Items list
                if (results['items'] != null &&
                    (results['items'] as List).isNotEmpty)
                  _buildItemsList(
                    theme: theme,
                    items: results['items'] as List,
                  ),
              ],
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(16),
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
            child: Row(
              children: [
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
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: onSave,
                    icon: CustomIconWidget(
                      iconName: 'save',
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text('Save Receipt'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build result field with confidence indicator
  Widget _buildResultField({
    required ThemeData theme,
    required String label,
    required String value,
    required double confidence,
    required String fieldName,
    required String icon,
  }) {
    final confidenceColor = _getConfidenceColor(confidence);
    final confidenceLabel = _getConfidenceLabel(confidence);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: confidenceColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: confidenceColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  confidenceLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: confidenceColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                onPressed: () => onEdit(fieldName),
                tooltip: 'Edit',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build category field with suggestions
  Widget _buildCategoryField({
    required ThemeData theme,
    required String value,
    required double confidence,
    required List<String> suggestions,
  }) {
    final confidenceColor = _getConfidenceColor(confidence);
    final confidenceLabel = _getConfidenceLabel(confidence);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: confidenceColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'category',
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Category',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: confidenceColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  confidenceLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: confidenceColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                onPressed: () => onEdit('category'),
                tooltip: 'Edit',
              ),
            ],
          ),
          if (suggestions.isNotEmpty) ...[
            SizedBox(height: 12),
            Text(
              'Suggestions:',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: suggestions.map((suggestion) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    suggestion,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// Build items list
  Widget _buildItemsList({required ThemeData theme, required List items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'receipt',
              color: theme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Items',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline, width: 1),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index] as Map<String, dynamic>;
              return Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['name'] ?? '',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      item['price'] ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Get confidence color based on value
  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.9) {
      return Color(0xFF059669); // High confidence - green
    } else if (confidence >= 0.7) {
      return Color(0xFFD97706); // Medium confidence - yellow
    } else {
      return Color(0xFFDC2626); // Low confidence - red
    }
  }

  /// Get confidence label based on value
  String _getConfidenceLabel(double confidence) {
    if (confidence >= 0.9) {
      return 'High';
    } else if (confidence >= 0.7) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }
}
