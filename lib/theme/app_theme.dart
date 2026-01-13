import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


/// A class that contains all theme configurations for the expense tracking application.
/// Implements Contemporary Financial Minimalism design with Professional Clarity Palette.
class AppTheme {
  AppTheme._();

  // Professional Clarity Palette - Light Theme Colors
  static const Color primaryLight = Color(0xFF2563EB); // Trust-building blue
  static const Color secondaryLight = Color(0xFF64748B); // Professional gray
  static const Color successLight = Color(0xFF059669); // Income indicators
  static const Color errorLight = Color(0xFFDC2626); // Expense indicators
  static const Color warningLight = Color(0xFFD97706); // Pending states
  static const Color surfaceLight = Color(0xFFF8FAFC); // Clean background
  static const Color cardLight = Color(0xFFFFFFFF); // Pure white cards
  static const Color borderLight = Color(0xFFE2E8F0); // Subtle separation
  static const Color textPrimaryLight = Color(0xFF0F172A); // High contrast
  static const Color textSecondaryLight = Color(0xFF475569); // Supporting info

  // Light theme emphasis colors
  static const Color textHighEmphasisLight = Color(0xFF0F172A);
  static const Color textMediumEmphasisLight = Color(0xFF475569);
  static const Color textDisabledLight = Color(0xFF94A3B8);

  // Dark theme colors (adapted from light theme for consistency)
  static const Color primaryDark = Color(
    0xFF3B82F6,
  ); // Lighter blue for dark mode
  static const Color secondaryDark = Color(0xFF94A3B8); // Lighter gray
  static const Color successDark = Color(0xFF10B981); // Lighter green
  static const Color errorDark = Color(0xFFEF4444); // Lighter red
  static const Color warningDark = Color(0xFFF59E0B); // Lighter orange
  static const Color surfaceDark = Color(0xFF0F172A); // Dark background
  static const Color cardDark = Color(0xFF1E293B); // Dark cards
  static const Color borderDark = Color(0xFF334155); // Dark borders
  static const Color textPrimaryDark = Color(0xFFF8FAFC); // Light text
  static const Color textSecondaryDark = Color(
    0xFFCBD5E1,
  ); // Secondary light text

  // Dark theme emphasis colors
  static const Color textHighEmphasisDark = Color(0xFFF8FAFC);
  static const Color textMediumEmphasisDark = Color(0xFFCBD5E1);
  static const Color textDisabledDark = Color(0xFF64748B);

  // Shadow colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);

  // Divider colors
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color dividerDark = Color(0xFF334155);

  /// Light theme - Contemporary Financial Minimalism
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: cardLight,
      primaryContainer: Color(0xFFDCEAFF),
      onPrimaryContainer: Color(0xFF001D36),
      secondary: secondaryLight,
      onSecondary: cardLight,
      secondaryContainer: Color(0xFFDDE3EA),
      onSecondaryContainer: Color(0xFF1A1F24),
      tertiary: successLight,
      onTertiary: cardLight,
      tertiaryContainer: Color(0xFFD1FAE5),
      onTertiaryContainer: Color(0xFF002114),
      error: errorLight,
      onError: cardLight,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: surfaceLight,
      onSurface: textPrimaryLight,
      onSurfaceVariant: textSecondaryLight,
      outline: borderLight,
      outlineVariant: Color(0xFFF1F5F9),
      shadow: shadowLight,
      scrim: Color(0xFF000000),
      inverseSurface: surfaceDark,
      onInverseSurface: textPrimaryDark,
      inversePrimary: primaryDark,
    ),
    scaffoldBackgroundColor: surfaceLight,
    cardColor: cardLight,
    dividerColor: dividerLight,

    // AppBar theme - Clean and professional
    appBarTheme: AppBarThemeData(
      backgroundColor: cardLight,
      foregroundColor: textPrimaryLight,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(color: textPrimaryLight, size: 24),
      actionsIconTheme: IconThemeData(color: textPrimaryLight, size: 24),
    ),

    // Card theme - Subtle elevation for hierarchy
    cardTheme: CardThemeData(
      color: cardLight,
      elevation: 2.0,
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom Navigation Bar theme - Bottom-heavy design
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cardLight,
      selectedItemColor: primaryLight,
      unselectedItemColor: textSecondaryLight,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
    ),

    // Floating Action Button theme - Context-aware FAB
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      foregroundColor: cardLight,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    ),

    // Elevated Button theme - Primary actions
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: cardLight,
        backgroundColor: primaryLight,
        disabledForegroundColor: textDisabledLight,
        disabledBackgroundColor: borderLight,
        elevation: 2.0,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: Size(88, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),

    // Outlined Button theme - Secondary actions
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLight,
        disabledForegroundColor: textDisabledLight,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: Size(88, 48),
        side: BorderSide(color: borderLight, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),

    // Text Button theme - Tertiary actions
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLight,
        disabledForegroundColor: textDisabledLight,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: Size(88, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),

    // Text theme - Inter font family for exceptional readability
    textTheme: _buildTextTheme(isLight: true),

    // Input Decoration theme - Smart input components
    inputDecorationTheme: InputDecorationThemeData(
      fillColor: cardLight,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderLight, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderLight, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorLight, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorLight, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderLight, width: 1),
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textSecondaryLight,
        letterSpacing: 0.15,
      ),
      floatingLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: primaryLight,
        letterSpacing: 0.4,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textDisabledLight,
        letterSpacing: 0.15,
      ),
      errorStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: errorLight,
        letterSpacing: 0.4,
      ),
      prefixIconColor: textSecondaryLight,
      suffixIconColor: textSecondaryLight,
    ),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        if (states.contains(WidgetState.disabled)) {
          return textDisabledLight;
        }
        return borderLight;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight.withValues(alpha: 0.5);
        }
        if (states.contains(WidgetState.disabled)) {
          return borderLight;
        }
        return textSecondaryLight.withValues(alpha: 0.3);
      }),
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        if (states.contains(WidgetState.disabled)) {
          return textDisabledLight;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(cardLight),
      side: BorderSide(color: borderLight, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        if (states.contains(WidgetState.disabled)) {
          return textDisabledLight;
        }
        return textSecondaryLight;
      }),
    ),

    // Progress Indicator theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryLight,
      linearTrackColor: borderLight,
      circularTrackColor: borderLight,
    ),

    // Slider theme
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryLight,
      inactiveTrackColor: borderLight,
      thumbColor: primaryLight,
      overlayColor: primaryLight.withValues(alpha: 0.2),
      valueIndicatorColor: primaryLight,
      valueIndicatorTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: cardLight,
      ),
    ),

    // Tab Bar theme - Progressive disclosure tabs
    tabBarTheme: TabBarThemeData(
      labelColor: primaryLight,
      unselectedLabelColor: textSecondaryLight,
      indicatorColor: primaryLight,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.25,
      ),
    ),

    // Tooltip theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimaryLight.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: cardLight,
        letterSpacing: 0.4,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      waitDuration: Duration(milliseconds: 500),
    ),

    // SnackBar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimaryLight,
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: cardLight,
        letterSpacing: 0.25,
      ),
      actionTextColor: successLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4.0,
    ),

    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: surfaceLight,
      deleteIconColor: textSecondaryLight,
      disabledColor: borderLight,
      selectedColor: primaryLight.withValues(alpha: 0.2),
      secondarySelectedColor: secondaryLight.withValues(alpha: 0.2),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimaryLight,
        letterSpacing: 0.25,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondaryLight,
        letterSpacing: 0.25,
      ),
      brightness: Brightness.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: borderLight, width: 1),
      ),
    ),

    // Dialog theme
    dialogTheme: DialogThemeData(
      backgroundColor: cardLight,
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
        letterSpacing: 0.15,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textSecondaryLight,
        letterSpacing: 0.5,
      ),
    ),

    // Bottom Sheet theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: cardLight,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      modalBackgroundColor: cardLight,
      modalElevation: 8.0,
    ),

    // Divider theme
    dividerTheme: DividerThemeData(color: dividerLight, thickness: 1, space: 1),
  );

  /// Dark theme - Contemporary Financial Minimalism (Dark Mode)
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: surfaceDark,
      primaryContainer: Color(0xFF1E3A8A),
      onPrimaryContainer: Color(0xFFDCEAFF),
      secondary: secondaryDark,
      onSecondary: surfaceDark,
      secondaryContainer: Color(0xFF334155),
      onSecondaryContainer: Color(0xFFDDE3EA),
      tertiary: successDark,
      onTertiary: surfaceDark,
      tertiaryContainer: Color(0xFF064E3B),
      onTertiaryContainer: Color(0xFFD1FAE5),
      error: errorDark,
      onError: surfaceDark,
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: surfaceDark,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textSecondaryDark,
      outline: borderDark,
      outlineVariant: Color(0xFF1E293B),
      shadow: shadowDark,
      scrim: Color(0xFF000000),
      inverseSurface: surfaceLight,
      onInverseSurface: textPrimaryLight,
      inversePrimary: primaryLight,
    ),
    scaffoldBackgroundColor: surfaceDark,
    cardColor: cardDark,
    dividerColor: dividerDark,

    // AppBar theme
    appBarTheme: AppBarThemeData(
      backgroundColor: cardDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(color: textPrimaryDark, size: 24),
      actionsIconTheme: IconThemeData(color: textPrimaryDark, size: 24),
    ),

    // Card theme
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 4.0,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom Navigation Bar theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cardDark,
      selectedItemColor: primaryDark,
      unselectedItemColor: textSecondaryDark,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
    ),

    // Floating Action Button theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryDark,
      foregroundColor: surfaceDark,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    ),

    // Elevated Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: surfaceDark,
        backgroundColor: primaryDark,
        disabledForegroundColor: textDisabledDark,
        disabledBackgroundColor: borderDark,
        elevation: 2.0,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: Size(88, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),

    // Outlined Button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryDark,
        disabledForegroundColor: textDisabledDark,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: Size(88, 48),
        side: BorderSide(color: borderDark, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),

    // Text Button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryDark,
        disabledForegroundColor: textDisabledDark,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: Size(88, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),

    // Text theme
    textTheme: _buildTextTheme(isLight: false),

    // Input Decoration theme
    inputDecorationTheme: InputDecorationThemeData(
      fillColor: cardDark,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderDark, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderDark, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: primaryDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorDark, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorDark, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderDark, width: 1),
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textSecondaryDark,
        letterSpacing: 0.15,
      ),
      floatingLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: primaryDark,
        letterSpacing: 0.4,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textDisabledDark,
        letterSpacing: 0.15,
      ),
      errorStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: errorDark,
        letterSpacing: 0.4,
      ),
      prefixIconColor: textSecondaryDark,
      suffixIconColor: textSecondaryDark,
    ),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        if (states.contains(WidgetState.disabled)) {
          return textDisabledDark;
        }
        return borderDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark.withValues(alpha: 0.5);
        }
        if (states.contains(WidgetState.disabled)) {
          return borderDark;
        }
        return textSecondaryDark.withValues(alpha: 0.3);
      }),
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        if (states.contains(WidgetState.disabled)) {
          return textDisabledDark;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(surfaceDark),
      side: BorderSide(color: borderDark, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        if (states.contains(WidgetState.disabled)) {
          return textDisabledDark;
        }
        return textSecondaryDark;
      }),
    ),

    // Progress Indicator theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryDark,
      linearTrackColor: borderDark,
      circularTrackColor: borderDark,
    ),

    // Slider theme
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryDark,
      inactiveTrackColor: borderDark,
      thumbColor: primaryDark,
      overlayColor: primaryDark.withValues(alpha: 0.2),
      valueIndicatorColor: primaryDark,
      valueIndicatorTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: surfaceDark,
      ),
    ),

    // Tab Bar theme
    tabBarTheme: TabBarThemeData(
      labelColor: primaryDark,
      unselectedLabelColor: textSecondaryDark,
      indicatorColor: primaryDark,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.25,
      ),
    ),

    // Tooltip theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimaryDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: surfaceDark,
        letterSpacing: 0.4,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      waitDuration: Duration(milliseconds: 500),
    ),

    // SnackBar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimaryDark,
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: surfaceDark,
        letterSpacing: 0.25,
      ),
      actionTextColor: successDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4.0,
    ),

    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: surfaceDark,
      deleteIconColor: textSecondaryDark,
      disabledColor: borderDark,
      selectedColor: primaryDark.withValues(alpha: 0.2),
      secondarySelectedColor: secondaryDark.withValues(alpha: 0.2),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
        letterSpacing: 0.25,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondaryDark,
        letterSpacing: 0.25,
      ),
      brightness: Brightness.dark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: borderDark, width: 1),
      ),
    ),

    // Dialog theme
    dialogTheme: DialogThemeData(
      backgroundColor: cardDark,
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
        letterSpacing: 0.15,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textSecondaryDark,
        letterSpacing: 0.5,
      ),
    ),

    // Bottom Sheet theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: cardDark,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      modalBackgroundColor: cardDark,
      modalElevation: 8.0,
    ),

    // Divider theme
    dividerTheme: DividerThemeData(color: dividerDark, thickness: 1, space: 1),
  );

  /// Helper method to build text theme based on brightness
  /// Uses Inter font family for exceptional mobile readability
  /// JetBrains Mono for financial data requiring exact character alignment
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis = isLight
        ? textHighEmphasisLight
        : textHighEmphasisDark;
    final Color textMediumEmphasis = isLight
        ? textMediumEmphasisLight
        : textMediumEmphasisDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    return TextTheme(
      // Display styles - Headings with Inter
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles - Dashboard scanning
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles - Section headers
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles - Transaction descriptions and form inputs
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles - Buttons and captions
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 1.25,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textMediumEmphasis,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: textDisabled,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Helper method to get monospace text style for financial data
  /// Uses JetBrains Mono for exact character alignment
  static TextStyle getMonospaceStyle({
    required bool isLight,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    final Color textColor = isLight
        ? textHighEmphasisLight
        : textHighEmphasisDark;

    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
      letterSpacing: 0,
      height: 1.5,
    );
  }

  /// Animation duration constants - Essential 200-300ms easing curves
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 400);

  /// Animation curves - Curves.easeInOut for state changes
  static const Curve defaultAnimationCurve = Curves.easeInOut;
  static const Curve emphasizedAnimationCurve = Curves.easeOutCubic;

  /// Elevation values - Material elevation for hierarchy
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  /// Border radius values - Consistent rounded corners
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;

  /// Spacing values - Generous spacing for professional warmth
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  /// Touch target sizes - Minimum 44pt/48dp touch areas
  static const double minTouchTargetSize = 48.0;
  static const double minTouchTargetSpacing = 8.0;
}