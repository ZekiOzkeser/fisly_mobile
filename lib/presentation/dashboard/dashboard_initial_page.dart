import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/quick_action_button_widget.dart';
import './widgets/summary_card_widget.dart';
import './widgets/transaction_item_widget.dart';

class DashboardInitialPage extends StatefulWidget {
  const DashboardInitialPage({super.key});

  @override
  State<DashboardInitialPage> createState() => _DashboardInitialPageState();
}

class _DashboardInitialPageState extends State<DashboardInitialPage> {
  bool _isSynced = true;
  bool _isRefreshing = false;

  // Mock data for transactions
  final List<Map<String, dynamic>> _recentTransactions = [
    {
      "id": "1",
      "supplier": "Migros",
      "amount": 245.50,
      "category": "Gıda",
      "categoryIcon": "shopping_cart",
      "categoryColor": Color(0xFF059669),
      "status": "approved",
      "date": DateTime.now().subtract(Duration(hours: 2)),
      "type": "expense",
    },
    {
      "id": "2",
      "supplier": "Shell",
      "amount": 380.00,
      "category": "Yakıt",
      "categoryIcon": "local_gas_station",
      "categoryColor": Color(0xFFD97706),
      "status": "pending",
      "date": DateTime.now().subtract(Duration(hours: 5)),
      "type": "expense",
    },
    {
      "id": "3",
      "supplier": "Müşteri Ödemesi",
      "amount": 1500.00,
      "category": "Gelir",
      "categoryIcon": "account_balance_wallet",
      "categoryColor": Color(0xFF059669),
      "status": "approved",
      "date": DateTime.now().subtract(Duration(days: 1)),
      "type": "income",
    },
    {
      "id": "4",
      "supplier": "Turkcell",
      "amount": 125.00,
      "category": "İletişim",
      "categoryIcon": "phone_android",
      "categoryColor": Color(0xFF2563EB),
      "status": "draft",
      "date": DateTime.now().subtract(Duration(days: 1, hours: 3)),
      "type": "expense",
    },
    {
      "id": "5",
      "supplier": "Starbucks",
      "amount": 85.50,
      "category": "Yemek",
      "categoryIcon": "restaurant",
      "categoryColor": Color(0xFFDC2626),
      "status": "approved",
      "date": DateTime.now().subtract(Duration(days: 2)),
      "type": "expense",
    },
  ];

  // Calculate daily totals
  double get _dailyIncome {
    final today = DateTime.now();
    return _recentTransactions
        .where(
          (t) =>
              (t["type"] as String) == "income" &&
              _isSameDay((t["date"] as DateTime), today),
        )
        .fold(0.0, (sum, t) => sum + (t["amount"] as double));
  }

  double get _dailyExpense {
    final today = DateTime.now();
    return _recentTransactions
        .where(
          (t) =>
              (t["type"] as String) == "expense" &&
              _isSameDay((t["date"] as DateTime), today),
        )
        .fold(0.0, (sum, t) => sum + (t["amount"] as double));
  }

  double get _dailyNet => _dailyIncome - _dailyExpense;

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate network refresh
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _isSynced = true;
    });
  }

  void _handleTransactionTap(Map<String, dynamic> transaction) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/receipt-detail', arguments: transaction);
  }

  void _handleTransactionEdit(Map<String, dynamic> transaction) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/manual-receipt-entry', arguments: transaction);
  }

  void _handleTransactionDelete(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Fiş Sil'),
        content: Text('Bu fişi silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _recentTransactions.removeWhere(
                  (t) => t["id"] == transaction["id"],
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Fiş silindi')));
            },
            child: Text('Sil', style: TextStyle(color: Color(0xFFDC2626))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: CustomScrollView(
        slivers: [
          // Sticky Header with greeting and sync status
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            elevation: 0,
            expandedHeight: 12.h,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hoş Geldiniz',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Finansal Özet',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: _isSynced
                                  ? Color(0xFF059669).withValues(alpha: 0.1)
                                  : Color(0xFFD97706).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: _isSynced
                                      ? 'cloud_done'
                                      : 'cloud_off',
                                  color: _isSynced
                                      ? Color(0xFF059669)
                                      : Color(0xFFD97706),
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  _isSynced ? 'Senkron' : 'Çevrimdışı',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: _isSynced
                                        ? Color(0xFF059669)
                                        : Color(0xFFD97706),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Summary Cards Section
          SliverToBoxAdapter(
            child: Container(
              height: 20.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                children: [
                  SummaryCardWidget(
                    title: 'Gelir',
                    amount: _dailyIncome,
                    icon: 'trending_up',
                    color: Color(0xFF059669),
                    isPositive: true,
                  ),
                  SizedBox(width: 3.w),
                  SummaryCardWidget(
                    title: 'Gider',
                    amount: _dailyExpense,
                    icon: 'trending_down',
                    color: Color(0xFFDC2626),
                    isPositive: false,
                  ),
                  SizedBox(width: 3.w),
                  SummaryCardWidget(
                    title: 'Net',
                    amount: _dailyNet,
                    icon: 'account_balance',
                    color: _dailyNet >= 0
                        ? Color(0xFF059669)
                        : Color(0xFFDC2626),
                    isPositive: _dailyNet >= 0,
                  ),
                ],
              ),
            ),
          ),

          // Quick Actions Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hızlı İşlemler',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      QuickActionButtonWidget(
                        icon: 'add_circle_outline',
                        label: 'Fiş Ekle',
                        color: Color(0xFF2563EB),
                        onTap: () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed('/manual-receipt-entry');
                        },
                      ),
                      QuickActionButtonWidget(
                        icon: 'qr_code_scanner',
                        label: 'Tara',
                        color: Color(0xFF059669),
                        onTap: () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed('/camera-scan');
                        },
                      ),
                      QuickActionButtonWidget(
                        icon: 'repeat',
                        label: 'Tekrarlayan',
                        color: Color(0xFFD97706),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Tekrarlayan işlem özelliği yakında eklenecek',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Recent Transactions Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Son İşlemler',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed('/receipt-list');
                    },
                    child: Text('Tümünü Gör'),
                  ),
                ],
              ),
            ),
          ),

          // Transactions List or Empty State
          _recentTransactions.isEmpty
              ? SliverFillRemaining(
                  child: EmptyStateWidget(
                    onAddReceipt: () {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed('/manual-receipt-entry');
                    },
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final transaction = _recentTransactions[index];
                    return TransactionItemWidget(
                      transaction: transaction,
                      onTap: () => _handleTransactionTap(transaction),
                      onEdit: () => _handleTransactionEdit(transaction),
                      onDelete: () => _handleTransactionDelete(transaction),
                    );
                  }, childCount: _recentTransactions.length),
                ),

          // Bottom padding for better scrolling experience
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
        ],
      ),
    );
  }
}
