import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_chart/fl_chart.dart';

/// Trend chart widget showing income vs expenses over time
/// Displays monthly trend line chart with interactive touch
class TrendChartWidget extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const TrendChartWidget({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<TrendChartWidget> createState() => _TrendChartWidgetState();
}

class _TrendChartWidgetState extends State<TrendChartWidget> {
  /// Mock data for monthly trends
  List<Map<String, dynamic>> _getTrendData() {
    return [
      {'month': 'Oca', 'income': 42000.0, 'expense': 35000.0},
      {'month': 'Şub', 'income': 38000.0, 'expense': 32000.0},
      {'month': 'Mar', 'income': 45000.0, 'expense': 38000.0},
      {'month': 'Nis', 'income': 48000.0, 'expense': 36000.0},
      {'month': 'May', 'income': 52000.0, 'expense': 40000.0},
      {'month': 'Haz', 'income': 45250.0, 'expense': 32180.5},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = _getTrendData();

    final maxValue = data.fold<double>(
      0,
      (max, item) => [
        max,
        item['income'] as double,
        item['expense'] as double,
      ].reduce((a, b) => a > b ? a : b),
    );

    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aylık Trend', style: theme.textTheme.titleMedium),
          SizedBox(height: 1.h),
          Row(
            children: [
              _buildLegendItem(
                theme: theme,
                color: Color(0xFF059669),
                label: 'Gelir',
              ),
              SizedBox(width: 4.w),
              _buildLegendItem(
                theme: theme,
                color: Color(0xFFDC2626),
                label: 'Gider',
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxValue / 5,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < data.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 1.h),
                            child: Text(
                              data[value.toInt()]['month'],
                              style: theme.textTheme.bodySmall,
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: maxValue / 5,
                      getTitlesWidget: (value, meta) => Text(
                        '₺${(value / 1000).toStringAsFixed(0)}k',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                    left: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                minX: 0,
                maxX: (data.length - 1).toDouble(),
                minY: 0,
                maxY: maxValue * 1.1,
                lineBarsData: [
                  // Income line
                  LineChartBarData(
                    spots: data.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value['income'] as double,
                      );
                    }).toList(),
                    isCurved: true,
                    color: Color(0xFF059669),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: Color(0xFF059669),
                            strokeWidth: 2,
                            strokeColor: theme.colorScheme.surface,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(0xFF059669).withValues(alpha: 0.1),
                    ),
                  ),
                  // Expense line
                  LineChartBarData(
                    spots: data.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value['expense'] as double,
                      );
                    }).toList(),
                    isCurved: true,
                    color: Color(0xFFDC2626),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: Color(0xFFDC2626),
                            strokeWidth: 2,
                            strokeColor: theme.colorScheme.surface,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(0xFFDC2626).withValues(alpha: 0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final isIncome = spot.barIndex == 0;
                        return LineTooltipItem(
                          '${isIncome ? 'Gelir' : 'Gider'}\n₺${spot.y.toStringAsFixed(0)}',
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required ThemeData theme,
    required Color color,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 1.w),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
