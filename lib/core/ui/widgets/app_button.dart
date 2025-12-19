import 'package:fisly_mobile/core/ui/theme/fisly_colors.dart';
import 'package:flutter/material.dart';

class FislyButtons {
  static final primary = ElevatedButton.styleFrom(
    backgroundColor: FislyColors.primary,
    foregroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    padding: const EdgeInsets.symmetric(vertical: 14),
    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
  );

  static final secondary = OutlinedButton.styleFrom(
    foregroundColor: FislyColors.primary,
    side: const BorderSide(color: FislyColors.primary),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    padding: const EdgeInsets.symmetric(vertical: 14),
    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
  );
}
