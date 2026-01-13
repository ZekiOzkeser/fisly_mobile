import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Supplier Field Widget
/// Autocomplete field with suggestions from recent entries
class SupplierFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<String> recentSuppliers;

  const SupplierFieldWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.recentSuppliers,
  });

  @override
  State<SupplierFieldWidget> createState() => _SupplierFieldWidgetState();
}

class _SupplierFieldWidgetState extends State<SupplierFieldWidget> {
  bool _showSuggestions = false;
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    widget.focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final text = widget.controller.text.toLowerCase();
    setState(() {
      if (text.isEmpty) {
        _filteredSuggestions = widget.recentSuppliers;
      } else {
        _filteredSuggestions = widget.recentSuppliers
            .where((supplier) => supplier.toLowerCase().contains(text))
            .toList();
      }
    });
  }

  void _onFocusChanged() {
    setState(() {
      _showSuggestions = widget.focusNode.hasFocus;
      if (_showSuggestions) {
        _filteredSuggestions = widget.recentSuppliers;
      }
    });
  }

  void _selectSuggestion(String suggestion) {
    widget.controller.text = suggestion;
    widget.focusNode.unfocus();
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                children: [
                  CustomIconWidget(
                    iconName: 'store',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Tedarikçi',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '*',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Color(0xFFDC2626),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Tedarikçi adı giriniz',
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
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tedarikçi adı giriniz';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        _showSuggestions && _filteredSuggestions.isNotEmpty
            ? Container(
                margin: EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Son Kullanılanlar',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Divider(height: 1),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _filteredSuggestions.length,
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        final suggestion = _filteredSuggestions[index];
                        return InkWell(
                          onTap: () => _selectSuggestion(suggestion),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'history',
                                  color: theme.colorScheme.onSurfaceVariant,
                                  size: 18,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    suggestion,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
