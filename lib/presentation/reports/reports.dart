import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/category_chart_widget.dart';
import './widgets/period_selector_widget.dart';
import './widgets/summary_card_widget.dart';
import './widgets/transaction_list_widget.dart';
import './widgets/trend_chart_widget.dart';

/// Reports screen for comprehensive financial analytics
/// Implements tab bar navigation with period selection and data visualization
class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> with SingleTickerProviderStateMixin {
  // Period selection state
  String _selectedPeriod = 'This Month';
  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();

  // Filter state
  String? _selectedAccount;
  final List<String> _selectedCategories = [];
  String? _selectedStatus;

  // Data refresh state
  bool _isRefreshing = false;
  DateTime _lastUpdate = DateTime.now();

  // Tab controller for chart types
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadReportData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Load report data based on selected period and filters
  Future<void> _loadReportData() async {
    setState(() => _isRefreshing = true);

    // Simulate data loading
    await Future.delayed(Duration(milliseconds: 800));

    setState(() {
      _isRefreshing = false;
      _lastUpdate = DateTime.now();
    });
  }

  /// Handle period selection change
  void _onPeriodChanged(String period, DateTime start, DateTime end) {
    setState(() {
      _selectedPeriod = period;
      _startDate = start;
      _endDate = end;
    });
    _loadReportData();
  }

  /// Handle filter changes
  void _onFilterChanged() {
    _loadReportData();
  }

  /// Show export options dialog
  void _showExportOptions() {
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
              'Raporu Dışa Aktar',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            _buildExportOption(
              icon: 'picture_as_pdf',
              title: 'PDF olarak dışa aktar',
              subtitle: 'Görsel rapor formatı',
              onTap: () {
                Navigator.pop(context);
                _exportAsPDF();
              },
            ),
            SizedBox(height: 2.h),
            _buildExportOption(
              icon: 'table_chart',
              title: 'Excel olarak dışa aktar',
              subtitle: 'Düzenlenebilir tablo formatı',
              onTap: () {
                Navigator.pop(context);
                _exportAsExcel();
              },
            ),
            SizedBox(height: 2.h),
            _buildExportOption(
              icon: 'email',
              title: 'E-posta ile paylaş',
              subtitle: 'Raporu e-posta ile gönder',
              onTap: () {
                Navigator.pop(context);
                _shareViaEmail();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  SizedBox(height: 0.5.h),
                  Text(subtitle, style: theme.textTheme.bodySmall),
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
    );
  }

  /// Export report as PDF
  Future<void> _exportAsPDF() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF raporu oluşturuluyor...'),
        duration: Duration(seconds: 2),
      ),
    );

    await Future.delayed(Duration(seconds: 2));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF raporu başarıyla oluşturuldu'),
        backgroundColor: Color(0xFF059669),
      ),
    );
  }

  /// Export report as Excel
  Future<void> _exportAsExcel() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Excel raporu oluşturuluyor...'),
        duration: Duration(seconds: 2),
      ),
    );

    await Future.delayed(Duration(seconds: 2));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Excel raporu başarıyla oluşturuldu'),
        backgroundColor: Color(0xFF059669),
      ),
    );
  }

  /// Share report via email
  Future<void> _shareViaEmail() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('E-posta uygulaması açılıyor...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Show filter options
  void _showFilterOptions() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.all(4.w),
          constraints: BoxConstraints(maxHeight: 70.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filtreler', style: theme.textTheme.titleLarge),
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        _selectedAccount = null;
                        _selectedCategories.clear();
                        _selectedStatus = null;
                      });
                    },
                    child: Text('Temizle'),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hesap', style: theme.textTheme.titleMedium),
                      SizedBox(height: 1.h),
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children: ['Tümü', 'Nakit', 'Banka', 'Kredi Kartı']
                            .map(
                              (account) => FilterChip(
                                label: Text(account),
                                selected:
                                    _selectedAccount == account ||
                                    (account == 'Tümü' &&
                                        _selectedAccount == null),
                                onSelected: (selected) {
                                  setModalState(() {
                                    _selectedAccount = account == 'Tümü'
                                        ? null
                                        : account;
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 2.h),
                      Text('Kategori', style: theme.textTheme.titleMedium),
                      SizedBox(height: 1.h),
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children:
                            [
                                  'Yemek',
                                  'Ulaşım',
                                  'Alışveriş',
                                  'Faturalar',
                                  'Eğlence',
                                ]
                                .map(
                                  (category) => FilterChip(
                                    label: Text(category),
                                    selected: _selectedCategories.contains(
                                      category,
                                    ),
                                    onSelected: (selected) {
                                      setModalState(() {
                                        if (selected) {
                                          _selectedCategories.add(category);
                                        } else {
                                          _selectedCategories.remove(category);
                                        }
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                      ),
                      SizedBox(height: 2.h),
                      Text('Durum', style: theme.textTheme.titleMedium),
                      SizedBox(height: 1.h),
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children: ['Tümü', 'Onaylandı', 'Beklemede', 'Taslak']
                            .map(
                              (status) => FilterChip(
                                label: Text(status),
                                selected:
                                    _selectedStatus == status ||
                                    (status == 'Tümü' &&
                                        _selectedStatus == null),
                                onSelected: (selected) {
                                  setModalState(() {
                                    _selectedStatus = status == 'Tümü'
                                        ? null
                                        : status;
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _onFilterChanged();
                },
                child: Text('Filtreleri Uygula'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Custom App Bar
        Container(
          color: theme.colorScheme.surface,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Raporlar', style: theme.textTheme.titleLarge),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Finansal Analiz',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: CustomIconWidget(
                          iconName: 'filter_list',
                          color: theme.colorScheme.onSurface,
                          size: 24,
                        ),
                        onPressed: _showFilterOptions,
                        tooltip: 'Filtrele',
                      ),
                      IconButton(
                        icon: CustomIconWidget(
                          iconName: 'file_download',
                          color: theme.colorScheme.onSurface,
                          size: 24,
                        ),
                        onPressed: _showExportOptions,
                        tooltip: 'Dışa Aktar',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Main Content
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadReportData,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Period Selector (Sticky Header)
                  Container(
                    color: theme.colorScheme.surface,
                    child: PeriodSelectorWidget(
                      selectedPeriod: _selectedPeriod,
                      onPeriodChanged: _onPeriodChanged,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Summary Cards
                  SummaryCardWidget(startDate: _startDate, endDate: _endDate),

                  SizedBox(height: 2.h),

                  // Charts Section with Tabs
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withValues(
                            alpha: 0.1,
                          ),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          tabs: [
                            Tab(text: 'Kategoriler'),
                            Tab(text: 'Trend'),
                            Tab(text: 'Dağılım'),
                          ],
                        ),
                        SizedBox(
                          height: 40.h,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              CategoryChartWidget(),
                              TrendChartWidget(
                                startDate: _startDate,
                                endDate: _endDate,
                              ),
                              CategoryChartWidget(showDonut: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Transaction List
                  TransactionListWidget(
                    startDate: _startDate,
                    endDate: _endDate,
                    selectedAccount: _selectedAccount,
                    selectedCategories: _selectedCategories,
                    selectedStatus: _selectedStatus,
                  ),

                  SizedBox(height: 2.h),

                  // Last Update Info
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      'Son güncelleme: ${_lastUpdate.hour.toString().padLeft(2, '0')}:${_lastUpdate.minute.toString().padLeft(2, '0')}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
