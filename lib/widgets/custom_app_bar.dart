import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom App Bar widget for expense tracking application.
/// Implements clean, professional interface with contextual actions.
///
/// Features:
/// - Adaptive title and actions based on screen context
/// - Optional search functionality
/// - Sync status indicator
/// - Offline mode indicator
/// - Platform-native styling
/// - Smooth transitions and animations
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar title text
  final String title;

  /// Optional subtitle for additional context
  final String? subtitle;

  /// Leading widget (typically back button or menu icon)
  final Widget? leading;

  /// Action widgets displayed on the right side
  final List<Widget>? actions;

  /// Whether to show the search icon
  final bool showSearch;

  /// Search callback when search icon is tapped
  final VoidCallback? onSearchTap;

  /// Whether to show sync status indicator
  final bool showSyncStatus;

  /// Sync status (true = synced, false = syncing, null = offline)
  final bool? isSynced;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom background color (overrides theme)
  final Color? backgroundColor;

  /// Custom foreground color (overrides theme)
  final Color? foregroundColor;

  /// Elevation value
  final double elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.showSearch = false,
    this.onSearchTap,
    this.showSyncStatus = false,
    this.isSynced,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 72.0 : 56.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appBarTheme = theme.appBarTheme;

    final effectiveBackgroundColor =
        backgroundColor ?? appBarTheme.backgroundColor ?? colorScheme.surface;

    final effectiveForegroundColor =
        foregroundColor ?? appBarTheme.foregroundColor ?? colorScheme.onSurface;

    // Build actions list with optional search and sync status
    final List<Widget> effectiveActions = [
      if (showSearch) _buildSearchAction(context, effectiveForegroundColor),
      if (showSyncStatus) _buildSyncStatusIndicator(context),
      ...?actions,
    ];

    return AppBar(
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: leading,
      title: subtitle != null
          ? _buildTitleWithSubtitle(context, effectiveForegroundColor)
          : _buildTitle(context, effectiveForegroundColor),
      actions: effectiveActions.isNotEmpty ? effectiveActions : null,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: theme.brightness,
      ),
    );
  }

  /// Builds the title widget
  Widget _buildTitle(BuildContext context, Color foregroundColor) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).appBarTheme.titleTextStyle?.copyWith(color: foregroundColor),
    );
  }

  /// Builds title with subtitle layout
  Widget _buildTitleWithSubtitle(BuildContext context, Color foregroundColor) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: centerTitle
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            color: foregroundColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2),
        Text(
          subtitle!,
          style: theme.textTheme.bodySmall?.copyWith(
            color: foregroundColor.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// Builds search action button
  Widget _buildSearchAction(BuildContext context, Color foregroundColor) {
    return IconButton(
      icon: Icon(Icons.search, color: foregroundColor),
      onPressed: onSearchTap,
      tooltip: 'Search receipts and transactions',
      splashRadius: 24,
    );
  }

  /// Builds sync status indicator
  Widget _buildSyncStatusIndicator(BuildContext context) {
    final theme = Theme.of(context);

    Widget statusIcon;
    Color statusColor;
    String statusTooltip;

    if (isSynced == null) {
      // Offline mode
      statusIcon = Icon(Icons.cloud_off_outlined, size: 20);
      statusColor = Color(0xFFD97706); // Warning color
      statusTooltip = 'Offline mode - Changes will sync when online';
    } else if (isSynced!) {
      // Synced
      statusIcon = Icon(Icons.cloud_done_outlined, size: 20);
      statusColor = Color(0xFF059669); // Success color
      statusTooltip = 'All changes synced';
    } else {
      // Syncing
      statusIcon = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
        ),
      );
      statusColor = Color(0xFF2563EB); // Primary color
      statusTooltip = 'Syncing changes...';
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Tooltip(
        message: statusTooltip,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconTheme(
            data: IconThemeData(color: statusColor),
            child: statusIcon,
          ),
        ),
      ),
    );
  }
}

/// Extension methods for common app bar configurations
extension CustomAppBarPresets on CustomAppBar {
  /// Creates an app bar for the dashboard screen
  static CustomAppBar dashboard({
    required BuildContext context,
    VoidCallback? onMenuTap,
    VoidCallback? onSearchTap,
    bool? isSynced,
  }) {
    return CustomAppBar(
      title: 'Dashboard',
      subtitle: 'Financial Overview',
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: onMenuTap,
        tooltip: 'Open menu',
      ),
      showSearch: true,
      onSearchTap: onSearchTap,
      showSyncStatus: true,
      isSynced: isSynced,
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined),
          onPressed: () {
            // Navigate to notifications
          },
          tooltip: 'Notifications',
        ),
      ],
    );
  }

  /// Creates an app bar for receipt list screen
  static CustomAppBar receiptList({
    required BuildContext context,
    VoidCallback? onSearchTap,
    VoidCallback? onFilterTap,
    bool? isSynced,
  }) {
    return CustomAppBar(
      title: 'Receipts',
      showSearch: true,
      onSearchTap: onSearchTap,
      showSyncStatus: true,
      isSynced: isSynced,
      actions: [
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: onFilterTap,
          tooltip: 'Filter receipts',
        ),
        IconButton(
          icon: Icon(Icons.sort),
          onPressed: () {
            // Show sort options
          },
          tooltip: 'Sort receipts',
        ),
      ],
    );
  }

  /// Creates an app bar for detail screens with back navigation
  static CustomAppBar detail({
    required BuildContext context,
    required String title,
    String? subtitle,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: title,
      subtitle: subtitle,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Back',
      ),
      actions: actions,
    );
  }

  /// Creates an app bar for reports screen
  static CustomAppBar reports({
    required BuildContext context,
    VoidCallback? onExportTap,
    VoidCallback? onFilterTap,
  }) {
    return CustomAppBar(
      title: 'Reports',
      subtitle: 'Financial Analytics',
      actions: [
        IconButton(
          icon: Icon(Icons.file_download_outlined),
          onPressed: onExportTap,
          tooltip: 'Export report',
        ),
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: onFilterTap,
          tooltip: 'Filter data',
        ),
      ],
    );
  }

  /// Creates an app bar for settings screen
  static CustomAppBar settings({required BuildContext context}) {
    return CustomAppBar(
      title: 'Settings',
      subtitle: 'Account & Preferences',
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Back',
      ),
    );
  }
}
