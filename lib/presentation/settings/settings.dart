import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';

/// Settings screen providing comprehensive app configuration
/// Organized sections: Account, Tax, Currency, Security, Integrations, Notifications, Data, About
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // User profile data
  final Map<String, dynamic> _userProfile = {
    "name": "Ahmet Yılmaz",
    "email": "ahmet.yilmaz@fisly.com",
    "role": "Admin",
    "avatar":
        "https://img.rocket.new/generatedImages/rocket_gen_img_1137886c8-1763293866701.png",
    "semanticLabel":
        "Profile photo of a man with short dark hair wearing a blue shirt",
  };

  // Tax configuration
  double _vatRate = 18.0;
  int _taxYear = 2026;
  bool _turkishTaxCompliance = true;

  // Currency settings
  String _primaryCurrency = "TRY";
  String _exchangeRateFrequency = "Daily";
  final List<String> _secondaryCurrencies = ["USD", "EUR"];

  // Security settings
  bool _biometricEnabled = false;
  bool _passcodeRequired = true;
  String _autoLockTimeout = "5 minutes";
  bool _sessionManagement = true;

  // Integration status
  final List<Map<String, dynamic>> _integrations = [
    {"name": "Logo", "connected": true, "lastSync": "2 hours ago"},
    {"name": "Mikro", "connected": false, "lastSync": "Never"},
    {"name": "Parasut", "connected": true, "lastSync": "1 day ago"},
  ];

  // Notification preferences
  bool _approvalNotifications = true;
  bool _syncNotifications = false;
  bool _expenseReminders = true;

  // Data management
  final String _storageUsed = "245 MB";
  final String _lastBackup = "Yesterday, 11:30 PM";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Ayarlar',
        subtitle: 'Hesap ve Tercihler',
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          tooltip: 'Geri',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 2.h),
              _buildAccountSection(theme),
              SizedBox(height: 2.h),
              _buildTaxConfigSection(theme),
              SizedBox(height: 2.h),
              _buildCurrencySection(theme),
              SizedBox(height: 2.h),
              _buildSecuritySection(theme),
              SizedBox(height: 2.h),
              _buildIntegrationSection(theme),
              SizedBox(height: 2.h),
              _buildNotificationSection(theme),
              SizedBox(height: 2.h),
              _buildDataManagementSection(theme),
              SizedBox(height: 2.h),
              _buildAboutSection(theme),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Account section with user profile
  Widget _buildAccountSection(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Hesap',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          InkWell(
            onTap: () {
              // Navigate to profile edit
            },
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CustomImageWidget(
                      imageUrl: _userProfile["avatar"] as String,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      semanticLabel: _userProfile["semanticLabel"] as String,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userProfile["name"] as String,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          _userProfile["email"] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _userProfile["role"] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
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
          ),
        ],
      ),
    );
  }

  /// Tax configuration section
  Widget _buildTaxConfigSection(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Vergi Yapılandırması',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          _buildSettingItem(
            theme: theme,
            title: 'KDV Oranı',
            subtitle: '%${_vatRate.toStringAsFixed(0)}',
            onTap: () => _showVatRateDialog(theme),
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 4.w),
          _buildSettingItem(
            theme: theme,
            title: 'Vergi Yılı',
            subtitle: _taxYear.toString(),
            onTap: () => _showTaxYearDialog(theme),
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 4.w),
          _buildSwitchItem(
            theme: theme,
            title: 'Türk Vergi Dairesi Uyumluluğu',
            value: _turkishTaxCompliance,
            onChanged: (value) => setState(() => _turkishTaxCompliance = value),
          ),
        ],
      ),
    );
  }

  /// Currency section
  Widget _buildCurrencySection(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Çoklu Para Birimi Desteği',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          _buildSettingItem(
            theme: theme,
            title: 'Birincil Para Birimi',
            subtitle: _primaryCurrency,
            onTap: () => _showCurrencyDialog(theme),
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 4.w),
          _buildSettingItem(
            theme: theme,
            title: 'Döviz Kuru Güncelleme Sıklığı',
            subtitle: _exchangeRateFrequency,
            onTap: () => _showExchangeRateFrequencyDialog(theme),
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 4.w),
          _buildSettingItem(
            theme: theme,
            title: 'İkincil Para Birimleri',
            subtitle: _secondaryCurrencies.join(', '),
            onTap: () => _showSecondaryCurrenciesDialog(theme),
          ),
        ],
      ),
    );
  }

  /// Security section
  Widget _buildSecuritySection(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Güvenlik',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          _buildSwitchItem(
            theme: theme,
            title: 'Biyometrik Kimlik Doğrulama',
            subtitle: 'Face ID / Touch ID / Parmak İzi',
            value: _biometricEnabled,
            onChanged: (value) => setState(() => _biometricEnabled = value),
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 4.w),
          _buildSwitchItem(
            theme: theme,
            title: 'Şifre Gereksinimi',
            value: _passcodeRequired,
            onChanged: (value) => setState(() => _passcodeRequired = value),
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 4.w),
          _buildSettingItem(
            theme: theme,
            title: 'Otomatik Kilit Zaman Aşımı',
            subtitle: _autoLockTimeout,
            onTap: () => _showAutoLockDialog(theme),
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 4.w),
          _buildSwitchItem(
            theme: theme,
            title: 'Oturum Yönetimi',
            value: _sessionManagement,
            onChanged: (value) => setState(() => _sessionManagement = value),
          ),
        ],
      ),
    );
  }

  /// Integration section
  Widget _buildIntegrationSection(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Entegrasyonlar',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          ...(_integrations as List).asMap().entries.map((entry) {
            final index = entry.key;
            final integration = entry.value as Map<String, dynamic>;
            return Column(
              children: [
                _buildIntegrationItem(
                  theme: theme,
                  name: integration["name"] as String,
                  connected: integration["connected"] as bool,
                  lastSync: integration["lastSync"] as String,
                ),
                if (index < _integrations.length - 1)
                  Divider(height: 1, color: theme.dividerColor, indent: 4.w),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// Notification section
  Widget _buildNotificationSection(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Bildirim Tercihleri',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          _buildSwitchItem(
            theme: theme,
            title: 'Onay Bildirimleri',
            value: _approvalNotifications,
            onChanged: (value) =>
                setState(() => _approvalNotifications = value),
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 4.w),
          _buildSwitchItem(
            theme: theme,
            title: 'Senkronizasyon Tamamlandı',
            value: _syncNotifications,
            onChanged: (value) => setState(() => _syncNotifications = value),
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 4.w),
          _buildSwitchItem(
            theme: theme,
            title: 'Harcama Hatırlatıcıları',
            value: _expenseReminders,
            onChanged: (value) => setState(() => _expenseReminders = value),
          ),
        ],
      ),
    );
  }

  /// Data management section
  Widget _buildDataManagementSection(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Veri Yönetimi',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          _buildSettingItem(
            theme: theme,
            title: 'Dışa Aktarma Seçenekleri',
            subtitle: 'PDF, Excel',
            onTap: () {
              // Show export options
            },
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 4.w),
          _buildSettingItem(
            theme: theme,
            title: 'Yedekleme Durumu',
            subtitle: _lastBackup,
            onTap: () {
              // Show backup options
            },
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 4.w),
          _buildSettingItem(
            theme: theme,
            title: 'Depolama Kullanımı',
            subtitle: _storageUsed,
            onTap: () {
              // Show storage details
            },
          ),
        ],
      ),
    );
  }

  /// About section
  Widget _buildAboutSection(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Hakkında',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          _buildSettingItem(
            theme: theme,
            title: 'Uygulama Sürümü',
            subtitle: '1.0.0',
            onTap: () {},
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 4.w),
          _buildSettingItem(
            theme: theme,
            title: 'Hizmet Şartları',
            onTap: () {
              // Open terms of service
            },
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 4.w),
          _buildSettingItem(
            theme: theme,
            title: 'Gizlilik Politikası',
            onTap: () {
              // Open privacy policy
            },
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 4.w),
          _buildSettingItem(
            theme: theme,
            title: 'Destek İletişim',
            subtitle: 'support@fisly.com',
            onTap: () {
              // Open support contact
            },
          ),
        ],
      ),
    );
  }

  /// Generic setting item with disclosure indicator
  Widget _buildSettingItem({
    required ThemeData theme,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
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

  /// Switch item for toggle settings
  Widget _buildSwitchItem({
    required ThemeData theme,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  /// Integration item with connection status
  Widget _buildIntegrationItem({
    required ThemeData theme,
    required String name,
    required bool connected,
    required String lastSync,
  }) {
    return InkWell(
      onTap: () {
        // Manage integration connection
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: connected
                    ? theme.colorScheme.tertiary.withValues(alpha: 0.1)
                    : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: connected ? 'check_circle' : 'cancel',
                  color: connected
                      ? theme.colorScheme.tertiary
                      : theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    connected ? 'Son senkronizasyon: $lastSync' : 'Bağlı değil',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
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

  /// Show VAT rate selection dialog
  void _showVatRateDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('KDV Oranı Seçin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [1.0, 8.0, 18.0, 20.0].map((rate) {
            return RadioListTile<double>(
              title: Text('%${rate.toStringAsFixed(0)}'),
              value: rate,
              groupValue: _vatRate,
              onChanged: (value) {
                setState(() => _vatRate = value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Show tax year selection dialog
  void _showTaxYearDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Vergi Yılı Seçin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [2024, 2025, 2026].map((year) {
            return RadioListTile<int>(
              title: Text(year.toString()),
              value: year,
              groupValue: _taxYear,
              onChanged: (value) {
                setState(() => _taxYear = value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Show currency selection dialog
  void _showCurrencyDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Para Birimi Seçin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['TRY', 'USD', 'EUR', 'GBP'].map((currency) {
            return RadioListTile<String>(
              title: Text(currency),
              value: currency,
              groupValue: _primaryCurrency,
              onChanged: (value) {
                setState(() => _primaryCurrency = value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Show exchange rate frequency dialog
  void _showExchangeRateFrequencyDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Güncelleme Sıklığı'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Hourly', 'Daily', 'Weekly'].map((frequency) {
            return RadioListTile<String>(
              title: Text(frequency),
              value: frequency,
              groupValue: _exchangeRateFrequency,
              onChanged: (value) {
                setState(() => _exchangeRateFrequency = value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Show secondary currencies dialog
  void _showSecondaryCurrenciesDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('İkincil Para Birimleri'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['USD', 'EUR', 'GBP', 'JPY'].map((currency) {
            return CheckboxListTile(
              title: Text(currency),
              value: _secondaryCurrencies.contains(currency),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    _secondaryCurrencies.add(currency);
                  } else {
                    _secondaryCurrencies.remove(currency);
                  }
                });
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tamam'),
          ),
        ],
      ),
    );
  }

  /// Show auto lock timeout dialog
  void _showAutoLockDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Otomatik Kilit Zaman Aşımı'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              [
                '1 minute',
                '5 minutes',
                '15 minutes',
                '30 minutes',
                'Never',
              ].map((timeout) {
                return RadioListTile<String>(
                  title: Text(timeout),
                  value: timeout,
                  groupValue: _autoLockTimeout,
                  onChanged: (value) {
                    setState(() => _autoLockTimeout = value!);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
        ),
      ),
    );
  }
}
