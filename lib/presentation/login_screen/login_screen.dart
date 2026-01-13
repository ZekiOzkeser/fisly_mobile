import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../services/api_client.dart';
import '../../services/auth_service.dart';

/// Login Screen for Fisly Receipt Management Application
/// Provides secure authentication with email/password and biometric options
/// Implements mobile-optimized input methods with inline validation
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final ApiClient _apiClient;
  late final AuthService _authService;
  String? _errorMessage;

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final bool _rememberEmail = false;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _authService = AuthService(_apiClient);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      await _authService.login(identifier: email, password: password);
      HapticFeedback.mediumImpact();

      if (mounted) {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _passwordError = _errorMessage;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage ?? 'Giriş başarısız.'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-posta adresi gerekli';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Geçerli bir e-posta adresi girin';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre gerekli';
    }
    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalı';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 8.h),
                      _buildLogo(theme),
                      SizedBox(height: 6.h),
                      _buildLoginForm(theme),
                      Spacer(),
                      _buildRegisterLink(theme),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(4.w),
          ),
          child: Center(
            child: Text(
              'F',
              style: theme.textTheme.displayMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Fisly',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Fiş Yönetimi ve Gider Takibi',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Giriş',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Hesabınıza giriş yapın',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),
          _buildEmailField(theme),
          SizedBox(height: 3.h),
          _buildPasswordField(theme),
          SizedBox(height: 2.h),
          _buildForgotPasswordLink(theme),
          SizedBox(height: 4.h),
          _buildLoginButton(theme),
          SizedBox(height: 3.h),
          _buildBiometricOption(theme),
        ],
      ),
    );
  }

  Widget _buildEmailField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          enabled: !_isLoading,
          decoration: InputDecoration(
            labelText: 'E-posta',
            hintText: 'ornek@fisly.com',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'email',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            errorText: null,
          ),
          validator: _validateEmail,
          onChanged: (value) {
            if (_emailError != null) {
              setState(() => _emailError = null);
            }
          },
        ),
        if (_emailError != null) ...[
          SizedBox(height: 1.h),
          Text(
            _emailError!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.done,
          enabled: !_isLoading,
          decoration: InputDecoration(
            labelText: 'Şifre',
            hintText: 'Şifrenizi girin',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            suffixIcon: IconButton(
              icon: CustomIconWidget(
                iconName: _isPasswordVisible ? 'visibility' : 'visibility_off',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
            ),
            errorText: null,
          ),
          validator: _validatePassword,
          onChanged: (value) {
            if (_passwordError != null) {
              setState(() => _passwordError = null);
            }
          },
          onFieldSubmitted: (_) => _handleLogin(),
        ),
        if (_passwordError != null) ...[
          SizedBox(height: 1.h),
          Text(
            _passwordError!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildForgotPasswordLink(ThemeData theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _isLoading
            ? null
            : () {
                Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
              },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        ),
        child: Text(
          'Şifremi Unuttum?',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)),
      ),
      child: _isLoading
          ? SizedBox(
              height: 5.w,
              width: 5.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.onPrimary,
                ),
              ),
            )
          : Text(
              'Giriş Yap',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
    );
  }

  Widget _buildBiometricOption(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: Divider(color: theme.colorScheme.outline)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'veya',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(child: Divider(color: theme.colorScheme.outline)),
      ],
    );
  }

  Widget _buildRegisterLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Yeni kullanıcı mısınız? ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  Navigator.of(context).pushNamed(AppRoutes.register);
                },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
          ),
          child: Text(
            'Kayıt Ol',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
