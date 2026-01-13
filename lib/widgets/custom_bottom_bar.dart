import 'package:flutter/material.dart';


/// Custom Bottom Navigation Bar widget for expense tracking application.
/// Implements Bottom-Heavy Design pattern with persistent access to core functions.
///
/// This widget is parameterized and reusable across different implementations.
/// Navigation logic is NOT hardcoded - it uses callbacks for flexibility.
///
/// Features:
/// - Fixed bottom navigation with 5 primary tabs
/// - Platform-native styling with Material Design
/// - Badge support for pending notifications
/// - Smooth transitions with micro-feedback animations
/// - Accessibility support with semantic labels
class CustomBottomBar extends StatelessWidget {
  /// Current selected index (0-4)
  final int currentIndex;

  /// Callback when navigation item is tapped
  final Function(int) onTap;

  /// Optional badge count for receipts tab (shows pending items)
  final int? receiptsBadgeCount;

  /// Optional badge count for reports tab (shows unreviewed reports)
  final int? reportsBadgeCount;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.receiptsBadgeCount,
    this.reportsBadgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor:
              theme.bottomNavigationBarTheme.unselectedItemColor,
          selectedLabelStyle: theme.bottomNavigationBarTheme.selectedLabelStyle,
          unselectedLabelStyle:
              theme.bottomNavigationBarTheme.unselectedLabelStyle,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            // Dashboard/Home - Financial overview and quick actions
            BottomNavigationBarItem(
              icon: _buildIcon(
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard,
                isSelected: currentIndex == 0,
              ),
              label: 'Dashboard',
              tooltip: 'Financial overview and quick actions',
            ),

            // Receipts - Receipt list and management
            BottomNavigationBarItem(
              icon: _buildIconWithBadge(
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long,
                isSelected: currentIndex == 1,
                badgeCount: receiptsBadgeCount,
              ),
              label: 'Receipts',
              tooltip: 'Receipt list and management',
            ),

            // Scan - Camera capture functionality (center position)
            BottomNavigationBarItem(
              icon: _buildScanIcon(isSelected: currentIndex == 2),
              label: 'Scan',
              tooltip: 'Camera capture for receipt digitization',
            ),

            // Reports - Financial analytics and exports
            BottomNavigationBarItem(
              icon: _buildIconWithBadge(
                icon: Icons.analytics_outlined,
                activeIcon: Icons.analytics,
                isSelected: currentIndex == 3,
                badgeCount: reportsBadgeCount,
              ),
              label: 'Reports',
              tooltip: 'Financial analytics and exports',
            ),

            // Profile - Settings and account management
            BottomNavigationBarItem(
              icon: _buildIcon(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                isSelected: currentIndex == 4,
              ),
              label: 'Profile',
              tooltip: 'Settings and account management',
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a standard navigation icon with active/inactive states
  Widget _buildIcon({
    required IconData icon,
    required IconData activeIcon,
    required bool isSelected,
  }) {
    return AnimatedScale(
      scale: isSelected ? 1.0 : 0.95,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Icon(isSelected ? activeIcon : icon, size: 24),
    );
  }

  /// Builds a navigation icon with optional badge indicator
  Widget _buildIconWithBadge({
    required IconData icon,
    required IconData activeIcon,
    required bool isSelected,
    int? badgeCount,
  }) {
    final hasNotification = badgeCount != null && badgeCount > 0;

    return AnimatedScale(
      scale: isSelected ? 1.0 : 0.95,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(isSelected ? activeIcon : icon, size: 24),
          if (hasNotification)
            Positioned(
              right: -8,
              top: -4,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: badgeCount > 9 ? 4 : 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFDC2626), // Error color for notifications
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  badgeCount > 99 ? '99+' : badgeCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Builds the special scan icon with elevated styling
  /// This icon is visually distinct as it's the most frequent action
  Widget _buildScanIcon({required bool isSelected}) {
    return AnimatedScale(
      scale: isSelected ? 1.1 : 1.0,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFF2563EB) // Primary color
              : Color(0xFF2563EB).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color(0xFF2563EB).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          isSelected ? Icons.qr_code_scanner : Icons.qr_code_scanner_outlined,
          size: 24,
          color: isSelected ? Colors.white : Color(0xFF2563EB),
        ),
      ),
    );
  }
}
