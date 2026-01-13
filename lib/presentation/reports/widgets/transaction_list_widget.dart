import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Transaction list widget for detailed transaction view
/// Supports filtering and sorting with same functionality as main receipt list
class TransactionListWidget extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String? selectedAccount;
  final List<String> selectedCategories;
  final String? selectedStatus;

  const TransactionListWidget({
    super.key,
    required this.startDate,
    required this.endDate,
    this.selectedAccount,
    this.selectedCategories = const [],
    this.selectedStatus,
  });

  @override
  State<TransactionListWidget> createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  String _sortBy = 'date';
  bool _sortAscending = false;

  /// Mock transaction data
  List<Map<String, dynamic>> _getTransactions() {
    final transactions = [
      {
        'id': 1,
        'supplier': 'Migros',
        'category': 'Yemek',
        'amount': 245.50,
        'date': DateTime.now().subtract(Duration(days: 1)),
        'account': 'Kredi Kartı',
        'status': 'Onaylandı',
        'type': 'expense',
        'icon': 'restaurant',
        'color': Color(0xFFEF4444),
      },
      {
        'id': 2,
        'supplier': 'Shell',
        'category': 'Ulaşım',
        'amount': 380.00,
        'date': DateTime.now().subtract(Duration(days: 2)),
        'account': 'Nakit',
        'status': 'Onaylandı',
        'type': 'expense',
        'icon': 'directions_car',
        'color': Color(0xFF3B82F6),
      },
      {
        'id': 3,
        'supplier': 'Zara',
        'category': 'Alışveriş',
        'amount': 1250.00,
        'date': DateTime.now().subtract(Duration(days: 3)),
        'account': 'Banka',
        'status': 'Beklemede',
        'type': 'expense',
        'icon': 'shopping_bag',
        'color': Color(0xFF8B5CF6),
      },
      {
        'id': 4,
        'supplier': 'Müşteri Ödemesi',
        'category': 'Gelir',
        'amount': 5000.00,
        'date': DateTime.now().subtract(Duration(days: 4)),
        'account': 'Banka',
        'status': 'Onaylandı',
        'type': 'income',
        'icon': 'account_balance_wallet',
        'color': Color(0xFF059669),
      },
      {
        'id': 5,
        'supplier': 'Türk Telekom',
        'category': 'Faturalar',
        'amount': 189.90,
        'date': DateTime.now().subtract(Duration(days: 5)),
        'account': 'Banka',
        'status': 'Onaylandı',
        'type': 'expense',
        'icon': 'receipt',
        'color': Color(0xFFF59E0B),
      },
    ];

    // Apply filters
    var filtered = transactions.where((t) {
      if (widget.selectedAccount != null &&
          t['account'] != widget.selectedAccount) {
        return false;
      }
      if (widget.selectedCategories.isNotEmpty &&
          !widget.selectedCategories.contains(t['category'])) {
        return false;
      }
      if (widget.selectedStatus != null &&
          t['status'] != widget.selectedStatus) {
        return false;
      }
      return true;
    }).toList();

    // Apply sorting
    filtered.sort((a, b) {
      int comparison;
      switch (_sortBy) {
        case 'amount':
          comparison = (a['amount'] as double).compareTo(b['amount'] as double);
          break;
        case 'supplier':
          comparison = (a['supplier'] as String).compareTo(
            b['supplier'] as String,
          );
          break;
        case 'date':
        default:
          comparison = (a['date'] as DateTime).compareTo(b['date'] as DateTime);
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  void _showSortOptions() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sıralama',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            _buildSortOption('Tarihe göre', 'date'),
            _buildSortOption('Tutara göre', 'amount'),
            _buildSortOption('Tedarikçiye göre', 'supplier'),
            SizedBox(height: 2.h),
            SwitchListTile(
              title: Text('Artan sıralama'),
              value: _sortAscending,
              onChanged: (value) {
                setState(() => _sortAscending = value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String value) {
    final theme = Theme.of(context);
    final isSelected = _sortBy == value;

    return ListTile(
      title: Text(label),
      trailing: isSelected
          ? CustomIconWidget(
              iconName: 'check',
              color: theme.colorScheme.primary,
              size: 24,
            )
          : null,
      onTap: () {
        setState(() => _sortBy = value);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final transactions = _getTransactions();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'İşlemler (${transactions.length})',
                  style: theme.textTheme.titleMedium,
                ),
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'sort',
                    color: theme.colorScheme.onSurface,
                    size: 24,
                  ),
                  onPressed: _showSortOptions,
                  tooltip: 'Sırala',
                ),
              ],
            ),
          ),
          Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, indent: 16.w),
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final isIncome = transaction['type'] == 'income';

              return ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.h,
                ),
                leading: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: (transaction['color'] as Color).withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: transaction['icon'],
                    color: transaction['color'],
                    size: 24,
                  ),
                ),
                title: Text(
                  transaction['supplier'],
                  style: theme.textTheme.titleSmall,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0.5.h),
                    Text(
                      transaction['category'],
                      style: theme.textTheme.bodySmall,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'calendar_today',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 12,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${(transaction['date'] as DateTime).day}/${(transaction['date'] as DateTime).month}/${(transaction['date'] as DateTime).year}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.3.h,
                          ),
                          decoration: BoxDecoration(
                            color: transaction['status'] == 'Onaylandı'
                                ? Color(0xFF059669).withValues(alpha: 0.1)
                                : Color(0xFFD97706).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            transaction['status'],
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: transaction['status'] == 'Onaylandı'
                                  ? Color(0xFF059669)
                                  : Color(0xFFD97706),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Text(
                  '${isIncome ? '+' : '-'}₺${(transaction['amount'] as double).toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isIncome ? Color(0xFF059669) : Color(0xFFDC2626),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed('/receipt-detail');
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
