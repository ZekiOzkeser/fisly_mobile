import 'package:flutter/material.dart';
import '../presentation/settings/settings.dart';
import '../presentation/receipt_detail/receipt_detail.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/register_screen/register_screen.dart';
import '../presentation/forgot_password_screen/forgot_password_screen.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/manual_receipt_entry/manual_receipt_entry.dart';
import '../presentation/reports/reports.dart';
import '../presentation/camera_scan/camera_scan.dart';
import '../presentation/receipt_list/receipt_list.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String settings = '/settings';
  static const String receiptDetail = '/receipt-detail';
  static const String login = '/login-screen';
  static const String register = '/register-screen';
  static const String forgotPassword = '/forgot-password-screen';
  static const String dashboard = '/dashboard';
  static const String manualReceiptEntry = '/manual-receipt-entry';
  static const String reports = '/reports';
  static const String cameraScan = '/camera-scan';
  static const String receiptList = '/receipt-list';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    settings: (context) => const Settings(),
    receiptDetail: (context) => const ReceiptDetail(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    dashboard: (context) => const Dashboard(),
    manualReceiptEntry: (context) => const ManualReceiptEntry(),
    reports: (context) => const Reports(),
    cameraScan: (context) => const CameraScan(),
    receiptList: (context) => const ReceiptList(),
    // TODO: Add your other routes here
  };
}
