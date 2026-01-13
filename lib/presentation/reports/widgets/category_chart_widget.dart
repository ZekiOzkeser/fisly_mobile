import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Category chart widget for spending visualization
/// Supports both horizontal bar chart and donut chart views
class CategoryChartWidget extends StatefulWidget {
  final bool showDonut;

  const CategoryChartWidget({super.key, this.showDonut = false});

  @override
  State<CategoryChartWidget> createState() => _CategoryChartWidgetState();
}

class _CategoryChartWidgetState extends State<CategoryChartWidget> {
  int _touchedIndex = -1;

  /// Mock data for category spending
  List<Map<String, dynamic>> _getCategoryData() {
    return [
      {
        'category': 'Yemek',
        'amount': 8500.00,
        'color': Color(0xFFEF4444),
        'icon': 'restaurant',
      },
      {
        'category': 'Ulaşım',
        'amount': 6200.00,
        'color': Color(0xFF3B82F6),
        'icon': 'directions_car',
      },
      {
        'category': 'Alışveriş',
        'amount': 5800.00,
        'color': Color(0xFF8B5CF6),
        'icon': 'shopping_bag',
      },
      {
        'category': 'Faturalar',
        'amount': 4500.00,
        'color': Color(0xFFF59E0B),
        'icon': 'receipt',
      },
      {
        'category': 'Eğlence',
        'amount': 3200.00,
        'color': Color(0xFF10B981),
        'icon': 'movie',
      },
      {
        'category': 'Sağlık',
        'amount': 2400.00,
        'color': Color(0xFFEC4899),
        'icon': 'local_hospital',
      },
      {
        'category': 'Diğer',
        'amount': 1580.50,
        'color': Color(0xFF6B7280),
        'icon': 'more_horiz',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return widget.showDonut ? _buildDonutChart() : _buildBarChart();
  }

  Widget _buildBarChart() {
    final theme = Theme.of(context);
    final data = _getCategoryData();
    final maxAmount = (data
        .map((e) => e['amount'] as double)
        .reduce((a, b) => a > b ? a : b));

    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kategoriye Göre Harcama', style: theme.textTheme.titleMedium),
          SizedBox(height: 2.h),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                final percentage =
                    ((item['amount'] as double) / maxAmount * 100);

                return Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(1.5.w),
                                decoration: BoxDecoration(
                                  color: (item['color'] as Color).withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CustomIconWidget(
                                  iconName: item['icon'],
                                  color: item['color'],
                                  size: 16,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                item['category'],
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Text(
                            '₺${(item['amount'] as double).toStringAsFixed(2)}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: percentage / 100,
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: item['color'],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChart() {
    final theme = Theme.of(context);
    final data = _getCategoryData();
    final total = data.fold<double>(
      0,
      (sum, item) => sum + (item['amount'] as double),
    );

    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kategori Dağılımı', style: theme.textTheme.titleMedium),
          SizedBox(height: 2.h),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              _touchedIndex = -1;
                              return;
                            }
                            _touchedIndex = pieTouchResponse
                                .touchedSection!
                                .touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: data.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        final isTouched = index == _touchedIndex;
                        final percentage =
                            ((item['amount'] as double) / total * 100);

                        return PieChartSectionData(
                          color: item['color'],
                          value: item['amount'],
                          title: '${percentage.toStringAsFixed(1)}%',
                          radius: isTouched ? 60 : 50,
                          titleStyle: TextStyle(
                            fontSize: isTouched ? 14 : 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data.map((item) {
                        final percentage =
                            ((item['amount'] as double) / total * 100);

                        return Padding(
                          padding: EdgeInsets.only(bottom: 1.5.h),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: item['color'],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['category'],
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    Text(
                                      '${percentage.toStringAsFixed(1)}%',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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
}
