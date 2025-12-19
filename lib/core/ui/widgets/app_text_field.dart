import 'package:fisly_mobile/core/ui/theme/fisly_colors.dart';
import 'package:flutter/material.dart';

class FislyTextStyles {
  static const h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: FislyColors.textPrimary,
  );

  static const h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: FislyColors.textPrimary,
  );

  static const body = TextStyle(fontSize: 14, color: FislyColors.textPrimary);

  static const bodyMuted = TextStyle(
    fontSize: 14,
    color: FislyColors.textSecondary,
  );

  static const caption = TextStyle(
    fontSize: 12,
    color: FislyColors.textSecondary,
  );
}
