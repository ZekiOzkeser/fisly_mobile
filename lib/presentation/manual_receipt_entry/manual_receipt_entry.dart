import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/amount_input_widget.dart';
import './widgets/category_picker_widget.dart';
import './widgets/date_picker_widget.dart';
import './widgets/description_field_widget.dart';
import './widgets/optional_fields_widget.dart';
import './widgets/supplier_field_widget.dart';

/// Manual Receipt Entry Screen
/// Enables efficient receipt creation with smart input assistance and mobile-optimized form design
class ManualReceiptEntry extends StatefulWidget {
  const ManualReceiptEntry({super.key});

  @override
  State<ManualReceiptEntry> createState() => _ManualReceiptEntryState();
}

class _ManualReceiptEntryState extends State<ManualReceiptEntry> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _supplierController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _supplierFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  // Form state
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  String? _selectedVatRate;
  List<String> _selectedTags = [];
  String? _selectedAccount;
  bool _addAnother = false;
  bool _hasUnsavedChanges = false;

  // Mock data for suggestions
  final List<String> _recentSuppliers = [
    'Migros',
    'CarrefourSA',
    'A101',
    'BİM',
    'Teknosa',
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Yemek', 'icon': 'restaurant', 'color': Color(0xFFEF4444)},
    {'name': 'Ulaşım', 'icon': 'directions_car', 'color': Color(0xFF3B82F6)},
    {'name': 'Ofis', 'icon': 'business', 'color': Color(0xFF8B5CF6)},
    {'name': 'Teknoloji', 'icon': 'devices', 'color': Color(0xFF10B981)},
    {'name': 'Sağlık', 'icon': 'local_hospital', 'color': Color(0xFFF59E0B)},
    {'name': 'Eğlence', 'icon': 'movie', 'color': Color(0xFFEC4899)},
  ];

  final List<String> _vatRates = ['%0', '%1', '%8', '%18'];

  final List<String> _accounts = [
    'Nakit',
    'Banka Hesabı',
    'Kredi Kartı',
    'Kurumsal Kart',
  ];

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onFormChanged);
    _supplierController.addListener(_onFormChanged);
    _descriptionController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _supplierController.dispose();
    _descriptionController.dispose();
    _amountFocusNode.dispose();
    _supplierFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {
      _hasUnsavedChanges = true;
    });
  }

  bool _isFormValid() {
    return _amountController.text.isNotEmpty &&
        _supplierController.text.isNotEmpty &&
        _selectedCategory != null;
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Değişiklikleri Kaydet?'),
        content: Text(
          'Kaydedilmemiş değişiklikleriniz var. Çıkmak istediğinizden emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Çık', style: TextStyle(color: Color(0xFFDC2626))),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _saveReceipt() {
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen zorunlu alanları doldurun'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    // Auto-save functionality
    setState(() {
      _hasUnsavedChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fiş başarıyla kaydedildi'),
        backgroundColor: Color(0xFF059669),
        duration: Duration(seconds: 2),
      ),
    );

    if (_addAnother) {
      _resetForm();
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _resetForm() {
    _amountController.clear();
    _supplierController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = null;
      _selectedDate = DateTime.now();
      _selectedVatRate = null;
      _selectedTags = [];
      _selectedAccount = null;
      _hasUnsavedChanges = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: CustomIconWidget(
              iconName: 'close',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.of(context, rootNavigator: true).pop();
              }
            },
          ),
          title: Text(
            'Fiş Ekle',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _isFormValid() ? _saveReceipt : null,
              child: Text(
                'Kaydet',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: _isFormValid()
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.4,
                        ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
        body: SizedBox.expand(
          child: KeyboardActions(
            config: _buildKeyboardActionsConfig(context),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                // Amount Input Section
                AmountInputWidget(
                  controller: _amountController,
                  focusNode: _amountFocusNode,
                ),
                SizedBox(height: 24),

                // Supplier Field Section
                SupplierFieldWidget(
                  controller: _supplierController,
                  focusNode: _supplierFocusNode,
                  recentSuppliers: _recentSuppliers,
                ),
                SizedBox(height: 24),

                // Category Picker Section
                CategoryPickerWidget(
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                      _hasUnsavedChanges = true;
                    });
                  },
                ),
                SizedBox(height: 24),

                // Date Picker Section
                DatePickerWidget(
                  selectedDate: _selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      _selectedDate = date;
                      _hasUnsavedChanges = true;
                    });
                  },
                ),
                SizedBox(height: 24),

                // Description Field Section
                DescriptionFieldWidget(
                  controller: _descriptionController,
                  focusNode: _descriptionFocusNode,
                ),
                SizedBox(height: 24),

                // Optional Fields Section
                OptionalFieldsWidget(
                  vatRates: _vatRates,
                  selectedVatRate: _selectedVatRate,
                  onVatRateSelected: (rate) {
                    setState(() {
                      _selectedVatRate = rate;
                      _hasUnsavedChanges = true;
                    });
                  },
                  selectedTags: _selectedTags,
                  onTagsChanged: (tags) {
                    setState(() {
                      _selectedTags = tags;
                      _hasUnsavedChanges = true;
                    });
                  },
                  accounts: _accounts,
                  selectedAccount: _selectedAccount,
                  onAccountSelected: (account) {
                    setState(() {
                      _selectedAccount = account;
                      _hasUnsavedChanges = true;
                    });
                  },
                ),
                SizedBox(height: 24),

                // Add Another Toggle
                Container(
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
                      Expanded(
                        child: Text(
                          'Başka Fiş Ekle',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Switch(
                        value: _addAnother,
                        onChanged: (value) {
                          setState(() {
                            _addAnother = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  KeyboardActionsConfig _buildKeyboardActionsConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Theme.of(context).colorScheme.surface,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _amountFocusNode,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Tamam',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ],
        ),
        KeyboardActionsItem(focusNode: _supplierFocusNode),
        KeyboardActionsItem(focusNode: _descriptionFocusNode),
      ],
    );
  }
}
