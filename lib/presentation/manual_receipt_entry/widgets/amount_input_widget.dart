import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Amount Input Widget
/// Prominently displayed amount input with large numeric keypad and Turkish formatting
class AmountInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const AmountInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormatter = CurrencyTextInputFormatter.currency(
      locale: 'tr_TR',
      symbol: '₺',
      decimalDigits: 2,
    );

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Tutar',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Text(
                '*',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Color(0xFFDC2626),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [currencyFormatter],
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
            decoration: InputDecoration(
              hintText: '0,00 ₺',
              hintStyle: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.3,
                ),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              filled: false,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tutar giriniz';
              }
              return null;
            },
          ),
          SizedBox(height: 8),
          Text(
            'Virgülden sonra 2 basamak girebilirsiniz',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
