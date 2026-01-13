import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Description Field Widget
/// Multi-line input with character counter
class DescriptionFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const DescriptionFieldWidget({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  State<DescriptionFieldWidget> createState() => _DescriptionFieldWidgetState();
}

class _DescriptionFieldWidgetState extends State<DescriptionFieldWidget> {
  static const int maxLength = 200;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLength = widget.controller.text.length;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.focusNode.hasFocus
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: widget.focusNode.hasFocus ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'description',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Açıklama',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                '$currentLength/$maxLength',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: currentLength > maxLength
                      ? Color(0xFFDC2626)
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            maxLines: 3,
            maxLength: maxLength,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Fiş açıklaması giriniz (opsiyonel)',
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.5,
                ),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              filled: false,
              counterText: '',
            ),
          ),
        ],
      ),
    );
  }
}
