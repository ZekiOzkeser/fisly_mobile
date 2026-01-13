import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Summary cards widget displaying key financial metrics
/// Shows total income, expenses, net profit/loss, and transaction count
class SummaryCardWidget extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const SummaryCardWidget({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  /// Mock data for summary metrics
  Map<String, dynamic> _getSummaryData() {
    return {
      'totalIncome': 45250.00,
      'totalExpenses': 32180.50,
      'netProfit': 13069.50,
      'transactionCount': 127,
      'incomeChange': 12.5,
      'expenseChange': -8.3,
      'profitChange': 45.2,
      'countChange': 15.0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = _getSummaryData();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context: context,
                  title: 'Toplam Gelir',
                  amount: data['totalIncome'],
                  change: data['incomeChange'],
                  icon: 'trending_up',
                  color: Color(0xFF059669),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildSummaryCard(
                  context: context,
                  title: 'Toplam Gider',
                  amount: data['totalExpenses'],
                  change: data['expenseChange'],
                  icon: 'trending_down',
                  color: Color(0xFFDC2626),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context: context,
                  title: 'Net Kar/Zarar',
                  amount: data['netProfit'],
                  change: data['profitChange'],
                  icon: 'account_balance_wallet',
                  color: data['netProfit'] >= 0
                      ? Color(0xFF059669)
                      : Color(0xFFDC2626),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildSummaryCard(
                  context: context,
                  title: 'İşlem Sayısı',
                  amount: data['transactionCount'].toDouble(),
                  change: data['countChange'],
                  icon: 'receipt_long',
                  color: theme.colorScheme.primary,
                  isCount: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required double amount,
    required double change,
    required String icon,
    required Color color,
    bool isCount = false,
  }) {
    final theme = Theme.of(context);
    final isPositive = change >= 0;

    return Container(
      padding: EdgeInsets.all(3.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(iconName: icon, color: color, size: 20),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: (isPositive ? Color(0xFF059669) : Color(0xFFDC2626))
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: isPositive ? 'arrow_upward' : 'arrow_downward',
                      color: isPositive ? Color(0xFF059669) : Color(0xFFDC2626),
                      size: 12,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${change.abs().toStringAsFixed(1)}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isPositive
                            ? Color(0xFF059669)
                            : Color(0xFFDC2626),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            isCount
                ? amount.toInt().toString()
                : '₺${amount.toStringAsFixed(2)}',
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
