import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Optional Fields Widget
/// VAT rate selector, tags input, and account assignment picker
class OptionalFieldsWidget extends StatelessWidget {
  final List<String> vatRates;
  final String? selectedVatRate;
  final Function(String?) onVatRateSelected;
  final List<String> selectedTags;
  final Function(List<String>) onTagsChanged;
  final List<String> accounts;
  final String? selectedAccount;
  final Function(String?) onAccountSelected;

  const OptionalFieldsWidget({
    super.key,
    required this.vatRates,
    required this.selectedVatRate,
    required this.onVatRateSelected,
    required this.selectedTags,
    required this.onTagsChanged,
    required this.accounts,
    required this.selectedAccount,
    required this.onAccountSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opsiyonel Alanlar',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),

        // VAT Rate Selector
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'percent',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'KDV Oranı',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: vatRates.map((rate) {
                  final isSelected = selectedVatRate == rate;
                  return InkWell(
                    onTap: () => onVatRateSelected(isSelected ? null : rate),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary.withValues(alpha: 0.1)
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withValues(
                                  alpha: 0.2,
                                ),
                        ),
                      ),
                      child: Text(
                        rate,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),

        // Tags Input
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'label',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Etiketler',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              selectedTags.isEmpty
                  ? InkWell(
                      onTap: () => _showTagDialog(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'add',
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Etiket Ekle',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...selectedTags.map(
                          (tag) => Chip(
                            label: Text(tag),
                            deleteIcon: CustomIconWidget(
                              iconName: 'close',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 16,
                            ),
                            onDeleted: () {
                              final newTags = List<String>.from(selectedTags);
                              newTags.remove(tag);
                              onTagsChanged(newTags);
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () => _showTagDialog(context),
                          child: Chip(
                            label: CustomIconWidget(
                              iconName: 'add',
                              color: theme.colorScheme.primary,
                              size: 16,
                            ),
                            backgroundColor: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
        SizedBox(height: 16),

        // Account Selector
        InkWell(
          onTap: () => _showAccountDialog(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'account_balance',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hesap',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        selectedAccount ?? 'Hesap Seçiniz',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: selectedAccount != null
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.5,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showTagDialog(BuildContext context) {
    final theme = Theme.of(context);
    final tagController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Etiket Ekle'),
        content: TextField(
          controller: tagController,
          decoration: InputDecoration(
            hintText: 'Etiket adı giriniz',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (tagController.text.isNotEmpty) {
                final newTags = List<String>.from(selectedTags);
                newTags.add(tagController.text);
                onTagsChanged(newTags);
                Navigator.of(context).pop();
              }
            },
            child: Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _showAccountDialog(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Hesap Seçiniz',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Divider(),
            ListView.builder(
              shrinkWrap: true,
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                final isSelected = selectedAccount == account;

                return ListTile(
                  leading: CustomIconWidget(
                    iconName: 'account_balance_wallet',
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  title: Text(
                    account,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  trailing: isSelected
                      ? CustomIconWidget(
                          iconName: 'check_circle',
                          color: theme.colorScheme.primary,
                          size: 24,
                        )
                      : null,
                  onTap: () {
                    onAccountSelected(account);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
