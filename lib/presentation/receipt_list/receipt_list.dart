import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../services/api_client.dart';
import '../../services/receipt_service.dart';
import '../../models/receipt_models.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/receipt_card_widget.dart';

/// Receipt List Screen - Comprehensive receipt management with advanced filtering
///
/// Features:
/// - Search bar with real-time filtering
/// - Horizontal scrolling filter chips
/// - Swipeable receipt cards (edit/delete)
/// - Pull-to-refresh synchronization
/// - Infinite scroll loading
/// - Empty state handling
/// - Offline support with cached data
class ReceiptList extends StatefulWidget {
  const ReceiptList({super.key});

  @override
  State<ReceiptList> createState() => _ReceiptListState();
}

class _ReceiptListState extends State<ReceiptList> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final ApiClient _apiClient;
  late final ReceiptService _receiptService;

  // Filter state
  final Map<String, dynamic> _activeFilters = {};
  String _searchQuery = '';

  // Loading states
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isRefreshing = false;

  // Data state
  List<Map<String, dynamic>> _receipts = [];
  List<Map<String, dynamic>> _filteredReceipts = [];
  bool _hasMore = true;
  int _currentPage = 1;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _receiptService = ReceiptService(_apiClient);
    _loadInitialData();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Load initial receipt data
  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    await _fetchReceipts(page: 1, append: false);
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  /// Handle pull-to-refresh
  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    await _fetchReceipts(page: 1, append: false);
    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _currentPage = 1;
        _hasMore = true;
      });
    }
  }

  /// Handle infinite scroll
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMore) {
        _loadMoreReceipts();
      }
    }
  }

  /// Load more receipts for infinite scroll
  Future<void> _loadMoreReceipts() async {
    setState(() => _isLoadingMore = true);
    await _fetchReceipts(page: _currentPage + 1, append: true);
    if (mounted) {
      setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _fetchReceipts({required int page, required bool append}) async {
    try {
      final response = await _receiptService.getReceipts(
        query: _searchController.text.isNotEmpty
            ? _searchController.text
            : null,
        page: page,
        pageSize: _pageSize,
      );

      final mapped = response.items.map(_mapReceiptListItem).toList();

      setState(() {
        if (append) {
          _receipts.addAll(mapped);
        } else {
          _receipts = mapped;
        }
        _applyFilters();
        _currentPage = page;
        _hasMore = response.items.length >= _pageSize;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Map<String, dynamic> _mapReceiptListItem(ReceiptListItem receipt) {
    final status = _mapStatus(receipt.status);
    final date = receipt.receiptDate != null
        ? DateTime.tryParse(receipt.receiptDate!)
        : DateTime.tryParse(receipt.uploadedAtUtc);

    return {
      'id': receipt.receiptDocumentId,
      'receiptParsedId': receipt.receiptParsedId,
      'supplier': receipt.companyName ?? 'Bilinmeyen',
      'description': receipt.receiptNo ?? (receipt.documentType ?? 'Fiş'),
      'amount': receipt.amount ?? 0.0,
      'currency': receipt.currency ?? 'TRY',
      'date': date ?? DateTime.now(),
      'category': 'office',
      'categoryName': receipt.documentType ?? 'Fiş',
      'status': status['code'],
      'statusName': status['label'],
      'hasVAT': true,
    };
  }

  Map<String, String> _mapStatus(int status) {
    final receiptStatus = ReceiptStatus.fromInt(status);
    switch (receiptStatus) {
      case ReceiptStatus.processing:
      case ReceiptStatus.queued:
      case ReceiptStatus.uploaded:
        return {'code': 'pending', 'label': 'İşleniyor'};
      case ReceiptStatus.done:
      case ReceiptStatus.processed:
        return {'code': 'approved', 'label': 'Hazır'};
      case ReceiptStatus.manualReview:
        return {'code': 'pending', 'label': 'Manuel İnceleme'};
      case ReceiptStatus.failed:
        return {'code': 'draft', 'label': 'Başarısız'};
      case ReceiptStatus.parsed:
        return {'code': 'pending', 'label': 'Ayrıştırıldı'};
      case ReceiptStatus.quarantined:
        return {'code': 'draft', 'label': 'Karantina'};
    }
  }

  /// Handle search query changes
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _applyFilters();
    });
  }

  /// Apply all active filters and search
  void _applyFilters() {
    _filteredReceipts = _receipts.where((receipt) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final supplier = (receipt['supplier'] as String).toLowerCase();
        final description = (receipt['description'] as String).toLowerCase();
        final amount = receipt['amount'].toString();

        if (!supplier.contains(_searchQuery) &&
            !description.contains(_searchQuery) &&
            !amount.contains(_searchQuery)) {
          return false;
        }
      }

      // Date range filter
      if (_activeFilters.containsKey('dateRange')) {
        final filterDate = _activeFilters['dateRange'] as String;
        final receiptDate = receipt['date'] as DateTime;

        if (filterDate == 'today') {
          if (!_isSameDay(receiptDate, DateTime.now())) return false;
        } else if (filterDate == 'week') {
          if (DateTime.now().difference(receiptDate).inDays > 7) return false;
        } else if (filterDate == 'month') {
          if (DateTime.now().difference(receiptDate).inDays > 30) return false;
        }
      }

      // Category filter
      if (_activeFilters.containsKey('category')) {
        if (receipt['category'] != _activeFilters['category']) return false;
      }

      // Status filter
      if (_activeFilters.containsKey('status')) {
        if (receipt['status'] != _activeFilters['status']) return false;
      }

      // VAT filter
      if (_activeFilters.containsKey('hasVAT')) {
        if (receipt['hasVAT'] != _activeFilters['hasVAT']) return false;
      }

      return true;
    }).toList();
  }

  /// Check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Show filter bottom sheet
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterSheet(),
    );
  }

  /// Build filter bottom sheet
  Widget _buildFilterSheet() {
    final theme = Theme.of(context);

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filtreler', style: theme.textTheme.titleLarge),
                TextButton(
                  onPressed: () {
                    setState(() => _activeFilters.clear());
                    _applyFilters();
                    Navigator.pop(context);
                  },
                  child: Text('Temizle'),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Filter options
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(4.w),
              children: [
                _buildFilterSection(
                  'Tarih Aralığı',
                  ['Bugün', 'Bu Hafta', 'Bu Ay', 'Tüm Zamanlar'],
                  'dateRange',
                  {
                    'Bugün': 'today',
                    'Bu Hafta': 'week',
                    'Bu Ay': 'month',
                    'Tüm Zamanlar': 'all',
                  },
                ),
                SizedBox(height: 3.h),
                _buildFilterSection(
                  'Kategori',
                  ['Yemek', 'Ulaşım', 'Ofis', 'Diğer'],
                  'category',
                  {
                    'Yemek': 'food',
                    'Ulaşım': 'transport',
                    'Ofis': 'office',
                    'Diğer': 'other',
                  },
                ),
                SizedBox(height: 3.h),
                _buildFilterSection(
                  'Durum',
                  ['Onaylandı', 'Beklemede', 'Taslak'],
                  'status',
                  {
                    'Onaylandı': 'approved',
                    'Beklemede': 'pending',
                    'Taslak': 'draft',
                  },
                ),
                SizedBox(height: 3.h),
                _buildSwitchFilter('KDV Dahil', 'hasVAT'),
              ],
            ),
          ),

          // Apply button
          Padding(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _applyFilters();
                  Navigator.pop(context);
                },
                child: Text('Filtreleri Uygula'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build filter section
  Widget _buildFilterSection(
    String title,
    List<String> options,
    String filterKey,
    Map<String, String> valueMap,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final value = valueMap[option];
            final isSelected = _activeFilters[filterKey] == value;

            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _activeFilters[filterKey] = value;
                  } else {
                    _activeFilters.remove(filterKey);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Build switch filter
  Widget _buildSwitchFilter(String title, String filterKey) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        Switch(
          value: _activeFilters[filterKey] ?? false,
          onChanged: (value) {
            setState(() {
              if (value) {
                _activeFilters[filterKey] = true;
              } else {
                _activeFilters.remove(filterKey);
              }
            });
          },
        ),
      ],
    );
  }

  /// Handle receipt edit
  void _onEditReceipt(Map<String, dynamic> receipt) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/manual-receipt-entry', arguments: receipt);
  }

  /// Handle receipt delete
  void _onDeleteReceipt(Map<String, dynamic> receipt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Fişi Sil'),
        content: Text('Bu fişi silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _receipts.remove(receipt);
                _filteredReceipts.remove(receipt);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Fiş silindi')));
            },
            child: Text('Sil'),
          ),
        ],
      ),
    );
  }

  /// Handle receipt tap
  void _onReceiptTap(Map<String, dynamic> receipt) {
    final receiptParsedId = receipt['receiptParsedId'] as String?;
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(
      '/receipt-detail',
      arguments: receiptParsedId ?? receipt,
    );
  }

  /// Remove filter chip
  void _removeFilter(String key) {
    setState(() {
      _activeFilters.remove(key);
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // Search bar (sticky header)
          Container(
            color: theme.colorScheme.surface,
            padding: EdgeInsets.fromLTRB(4.w, 6.h, 4.w, 2.h),
            child: Column(
              children: [
                // Search field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tedarikçi, açıklama veya tutar ara...',
                    prefixIcon: CustomIconWidget(
                      iconName: 'search',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: CustomIconWidget(
                              iconName: 'close',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.5.h,
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Filter chips
                if (_activeFilters.isNotEmpty)
                  SizedBox(
                    height: 5.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Filter button
                        FilterChipWidget(
                          label: 'Filtreler',
                          icon: 'filter_list',
                          count: _activeFilters.length,
                          onTap: _showFilterSheet,
                        ),

                        SizedBox(width: 2.w),

                        // Active filter chips
                        ..._activeFilters.entries.map((entry) {
                          String label = '';
                          if (entry.key == 'dateRange') {
                            label = entry.value == 'today'
                                ? 'Bugün'
                                : entry.value == 'week'
                                ? 'Bu Hafta'
                                : 'Bu Ay';
                          } else if (entry.key == 'category') {
                            label = entry.value == 'food'
                                ? 'Yemek'
                                : entry.value == 'transport'
                                ? 'Ulaşım'
                                : entry.value == 'office'
                                ? 'Ofis'
                                : 'Diğer';
                          } else if (entry.key == 'status') {
                            label = entry.value == 'approved'
                                ? 'Onaylandı'
                                : entry.value == 'pending'
                                ? 'Beklemede'
                                : 'Taslak';
                          } else if (entry.key == 'hasVAT') {
                            label = 'KDV Dahil';
                          }

                          return Padding(
                            padding: EdgeInsets.only(right: 2.w),
                            child: FilterChipWidget(
                              label: label,
                              isActive: true,
                              onRemove: () => _removeFilter(entry.key),
                            ),
                          );
                        }),
                      ],
                    ),
                  )
                else
                  GestureDetector(
                    onTap: _showFilterSheet,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'filter_list',
                            color: theme.colorScheme.onPrimaryContainer,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Filtrele',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Receipt list
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _filteredReceipts.isEmpty
                ? EmptyStateWidget(
                    hasFilters:
                        _activeFilters.isNotEmpty || _searchQuery.isNotEmpty,
                    onClearFilters: () {
                      setState(() {
                        _activeFilters.clear();
                        _searchController.clear();
                        _applyFilters();
                      });
                    },
                    onAddReceipt: () {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed('/manual-receipt-entry');
                    },
                  )
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      itemCount:
                          _filteredReceipts.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _filteredReceipts.length) {
                          return _buildLoadingMoreIndicator();
                        }

                        final receipt = _filteredReceipts[index];

                        return Slidable(
                          key: ValueKey(receipt['id']),
                          startActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) => _onEditReceipt(receipt),
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                icon: Icons.edit,
                                label: 'Düzenle',
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) => _onDeleteReceipt(receipt),
                                backgroundColor: theme.colorScheme.error,
                                foregroundColor: theme.colorScheme.onError,
                                icon: Icons.delete,
                                label: 'Sil',
                              ),
                            ],
                          ),
                          child: ReceiptCardWidget(
                            receipt: receipt,
                            onTap: () => _onReceiptTap(receipt),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),

      // Floating action button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushNamed('/manual-receipt-entry');
        },
        icon: CustomIconWidget(
          iconName: 'add',
          color: theme.colorScheme.onPrimary,
          size: 24,
        ),
        label: Text('Fiş Ekle'),
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: 8,
      itemBuilder: (context, index) {
        return _buildSkeletonCard();
      },
    );
  }

  /// Build skeleton loading card
  Widget _buildSkeletonCard() {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40.w,
                      height: 2.h,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      width: 25.w,
                      height: 1.5.h,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 20.w,
                height: 2.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build loading more indicator
  Widget _buildLoadingMoreIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  /// Generate mock receipt data
  List<Map<String, dynamic>> _generateMockReceipts({int page = 1}) {
    final suppliers = [
      'Migros',
      'CarrefourSA',
      'A101',
      'BIM',
      'Şok Market',
      'Starbucks',
      'Burger King',
      'McDonald\'s',
      'KFC',
      'Domino\'s',
      'Shell',
      'BP',
      'Opet',
      'Petrol Ofisi',
      'Total',
      'Teknosa',
      'Media Markt',
      'Vatan Bilgisayar',
      'D&R',
      'Kitapyurdu',
    ];

    final categories = ['food', 'transport', 'office', 'other'];
    final categoryNames = ['Yemek', 'Ulaşım', 'Ofis', 'Diğer'];
    final statuses = ['approved', 'pending', 'draft'];
    final statusNames = ['Onaylandı', 'Beklemede', 'Taslak'];

    return List.generate(10, (index) {
      final actualIndex = (page - 1) * 10 + index;
      final category = categories[actualIndex % categories.length];
      final status = statuses[actualIndex % statuses.length];

      return {
        'id': 'receipt_${actualIndex + 1}',
        'supplier': suppliers[actualIndex % suppliers.length],
        'description':
            'Alışveriş - ${suppliers[actualIndex % suppliers.length]}',
        'amount': (50 + (actualIndex * 37) % 450).toDouble(),
        'date': DateTime.now().subtract(Duration(days: actualIndex)),
        'category': category,
        'categoryName': categoryNames[categories.indexOf(category)],
        'status': status,
        'statusName': statusNames[statuses.indexOf(status)],
        'hasVAT': actualIndex % 3 == 0,
        'vatAmount': actualIndex % 3 == 0
            ? (50 + (actualIndex * 37) % 450) * 0.18
            : 0.0,
      };
    });
  }
}
