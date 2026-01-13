import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Receipt Details Tab Widget
/// Displays and allows editing of receipt information
class ReceiptDetailsTabWidget extends StatefulWidget {
  final Map<String, dynamic> receiptData;
  final bool isEditMode;
  final Function(String, dynamic) onDataChanged;

  const ReceiptDetailsTabWidget({
    super.key,
    required this.receiptData,
    required this.isEditMode,
    required this.onDataChanged,
  });

  @override
  State<ReceiptDetailsTabWidget> createState() =>
      _ReceiptDetailsTabWidgetState();
}

class _ReceiptDetailsTabWidgetState extends State<ReceiptDetailsTabWidget> {
  late TextEditingController _amountController;
  late TextEditingController _supplierController;
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;

  final List<String> _categories = [
    'Teknoloji',
    'Ofis Malzemeleri',
    'Yemek',
    'Ulaşım',
    'Konaklama',
    'Diğer',
  ];

  final List<String> _accounts = [
    'İş Bankası Hesabı',
    'Garanti Bankası Hesabı',
    'Nakit',
    'Kredi Kartı',
  ];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: (widget.receiptData['amount'] as double).toStringAsFixed(2),
    );
    _supplierController = TextEditingController(
      text: widget.receiptData['supplier'] as String,
    );
    _descriptionController = TextEditingController(
      text: widget.receiptData['description'] as String,
    );
    _notesController = TextEditingController(
      text: widget.receiptData['notes'] as String? ?? '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _supplierController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAmountCard(theme),
          SizedBox(height: 2.h),
          _buildInfoCard(theme),
          SizedBox(height: 2.h),
          _buildCategoryCard(theme),
          SizedBox(height: 2.h),
          _buildDescriptionCard(theme),
          SizedBox(height: 2.h),
          _buildTagsCard(theme),
          SizedBox(height: 2.h),
          _buildNotesCard(theme),
          SizedBox(height: 2.h),
          _buildMetadataCard(theme),
        ],
      ),
    );
  }

  Widget _buildAmountCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tutar',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            widget.isEditMode
                ? TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      prefixText: '₺ ',
                      suffixText: widget.receiptData['currency'] as String,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      final amount = double.tryParse(value);
                      if (amount != null) {
                        widget.onDataChanged('amount', amount);
                      }
                    },
                  )
                : Row(
                    children: [
                      Text(
                        '₺ ${(widget.receiptData['amount'] as double).toStringAsFixed(2)}',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        widget.receiptData['currency'] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            _buildInfoRow(
              theme,
              'Tedarikçi',
              widget.isEditMode
                  ? TextField(
                      controller: _supplierController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (value) {
                        widget.onDataChanged('supplier', value);
                      },
                    )
                  : Text(
                      widget.receiptData['supplier'] as String,
                      style: theme.textTheme.bodyLarge,
                    ),
            ),
            Divider(height: 3.h),
            _buildInfoRow(
              theme,
              'Tarih',
              widget.isEditMode
                  ? InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: widget.receiptData['date'] as DateTime,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          widget.onDataChanged('date', date);
                          setState(() {});
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.outline),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'calendar_today',
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              DateFormat(
                                'dd/MM/yyyy',
                              ).format(widget.receiptData['date'] as DateTime),
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Text(
                      DateFormat(
                        'dd/MM/yyyy',
                      ).format(widget.receiptData['date'] as DateTime),
                      style: theme.textTheme.bodyLarge,
                    ),
            ),
            Divider(height: 3.h),
            _buildInfoRow(
              theme,
              'Hesap',
              widget.isEditMode
                  ? DropdownButtonFormField<String>(
                      initialValue: widget.receiptData['account'] as String,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: _accounts.map((account) {
                        return DropdownMenuItem(
                          value: account,
                          child: Text(account),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          widget.onDataChanged('account', value);
                          setState(() {});
                        }
                      },
                    )
                  : Text(
                      widget.receiptData['account'] as String,
                      style: theme.textTheme.bodyLarge,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kategori',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            widget.isEditMode
                ? DropdownButtonFormField<String>(
                    initialValue: widget.receiptData['category'] as String,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName:
                              widget.receiptData['categoryIcon'] as String,
                          color: Color(
                            widget.receiptData['categoryColor'] as int,
                          ),
                          size: 24,
                        ),
                      ),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        widget.onDataChanged('category', value);
                        setState(() {});
                      }
                    },
                  )
                : Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: Color(
                        widget.receiptData['categoryColor'] as int,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName:
                              widget.receiptData['categoryIcon'] as String,
                          color: Color(
                            widget.receiptData['categoryColor'] as int,
                          ),
                          size: 24,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          widget.receiptData['category'] as String,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Açıklama',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            widget.isEditMode
                ? TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Açıklama giriniz',
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      widget.onDataChanged('description', value);
                    },
                  )
                : Text(
                    widget.receiptData['description'] as String,
                    style: theme.textTheme.bodyLarge,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsCard(ThemeData theme) {
    final tags = (widget.receiptData['tags'] as List).cast<String>();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Etiketler',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.isEditMode)
                  IconButton(
                    icon: CustomIconWidget(
                      iconName: 'add',
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    onPressed: () {
                      _showAddTagDialog(theme);
                    },
                  ),
              ],
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  deleteIcon: widget.isEditMode
                      ? CustomIconWidget(
                          iconName: 'close',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 18,
                        )
                      : null,
                  onDeleted: widget.isEditMode
                      ? () {
                          setState(() {
                            tags.remove(tag);
                          });
                          widget.onDataChanged('tags', tags);
                        }
                      : null,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notlar',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            widget.isEditMode
                ? TextField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Not ekleyiniz',
                    ),
                    maxLines: 4,
                    onChanged: (value) {
                      widget.onDataChanged('notes', value);
                    },
                  )
                : Text(
                    widget.receiptData['notes'] as String? ?? 'Not eklenmemiş',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color:
                          (widget.receiptData['notes'] as String?)?.isEmpty ??
                              true
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.onSurface,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bilgiler',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildMetadataRow(
              theme,
              'Oluşturan',
              widget.receiptData['createdBy'] as String,
            ),
            SizedBox(height: 1.h),
            _buildMetadataRow(
              theme,
              'Oluşturma Tarihi',
              DateFormat(
                'dd/MM/yyyy HH:mm',
              ).format(widget.receiptData['createdDate'] as DateTime),
            ),
            SizedBox(height: 1.h),
            _buildMetadataRow(
              theme,
              'Son Güncelleme',
              DateFormat(
                'dd/MM/yyyy HH:mm',
              ).format(widget.receiptData['lastModified'] as DateTime),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, String label, Widget value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30.w,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(child: value),
      ],
    );
  }

  Widget _buildMetadataRow(ThemeData theme, String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 40.w,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(child: Text(value, style: theme.textTheme.bodySmall)),
      ],
    );
  }

  void _showAddTagDialog(ThemeData theme) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Etiket Ekle'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Etiket adı',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final tags = (widget.receiptData['tags'] as List)
                    .cast<String>();
                setState(() {
                  tags.add(controller.text);
                });
                widget.onDataChanged('tags', tags);
                Navigator.pop(context);
              }
            },
            child: Text('Ekle'),
          ),
        ],
      ),
    );
  }
}
