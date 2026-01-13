import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Period selector widget for reports
/// Provides preset period options and custom date range picker
class PeriodSelectorWidget extends StatelessWidget {
  final String selectedPeriod;
  final Function(String period, DateTime start, DateTime end) onPeriodChanged;

  const PeriodSelectorWidget({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  /// Calculate date range for preset periods
  Map<String, DateTime> _calculatePeriodDates(String period) {
    final now = DateTime.now();
    DateTime start;
    DateTime end = now;

    switch (period) {
      case 'This Month':
        start = DateTime(now.year, now.month, 1);
        break;
      case 'Last Month':
        start = DateTime(now.year, now.month - 1, 1);
        end = DateTime(now.year, now.month, 0);
        break;
      case 'Quarter':
        final currentQuarter = ((now.month - 1) ~/ 3) + 1;
        start = DateTime(now.year, (currentQuarter - 1) * 3 + 1, 1);
        break;
      case 'Year':
        start = DateTime(now.year, 1, 1);
        break;
      default:
        start = now.subtract(Duration(days: 30));
    }

    return {'start': start, 'end': end};
  }

  /// Show custom date range picker
  Future<void> _showCustomDatePicker(BuildContext context) async {
    final theme = Theme.of(context);
    final now = DateTime.now();

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: now.subtract(Duration(days: 30)),
        end: now,
      ),
      builder: (context, child) => Theme(
        data: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: theme.colorScheme.primary,
            onPrimary: theme.colorScheme.onPrimary,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      onPeriodChanged('Custom', picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final periods = ['This Month', 'Last Month', 'Quarter', 'Year', 'Custom'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dönem Seçin', style: theme.textTheme.titleMedium),
          SizedBox(height: 1.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: periods.map((period) {
                final isSelected = selectedPeriod == period;

                return Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: ChoiceChip(
                    label: Text(
                      period == 'This Month'
                          ? 'Bu Ay'
                          : period == 'Last Month'
                          ? 'Geçen Ay'
                          : period == 'Quarter'
                          ? 'Çeyrek'
                          : period == 'Year'
                          ? 'Yıl'
                          : 'Özel',
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        if (period == 'Custom') {
                          _showCustomDatePicker(context);
                        } else {
                          final dates = _calculatePeriodDates(period);
                          onPeriodChanged(
                            period,
                            dates['start']!,
                            dates['end']!,
                          );
                        }
                      }
                    },
                    selectedColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    backgroundColor: theme.colorScheme.surface,
                    side: BorderSide(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
