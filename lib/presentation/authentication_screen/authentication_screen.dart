import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart';

import '../../core/app_export.dart';
import '../../localization/app_localizations.dart';
import '../../main.dart';
import './widgets/language_picker_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/role_selection_widget.dart';
import './widgets/registration_form_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  String _selectedRole = 'ngo';
  String _selectedLanguage = 'en';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isRegister = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('app_locale') ?? 'en';
    setState(() {
      _selectedLanguage = savedLanguage;
    });
  }

  Future<void> _onLanguageChanged(String language) async {
    setState(() {
      _selectedLanguage = language;
    });

    // Update app locale and save
    final newLocale = Locale(language);
    MyApp.setLocale(context, newLocale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', language);
  }

  /// 🔥 REAL BACKEND LOGIN
  Future<void> _onLogin(String email, String password) async {
    final localizations = AppLocalizations.of(context);

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

      final response = await dio.post('/auth/login', data: {
        "email": email,
        "password": password,
      });

      final data = response.data;
      final token = data['token'];
      final user = data['user'];

      // Save role + token in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', user['role']);
      await prefs.setString('auth_token', token);

      HapticFeedback.lightImpact();

      // Navigate based on role from backend
      String route;
      switch (user['role']) {
        case 'NGO':
          route = AppRoutes.ngoHome;
          break;
        case 'ADMIN':
          route = AppRoutes.adminDashboard;
          break;
        case 'COMPANY':
          route = AppRoutes.carbonCreditMarketplace;
          break;
        default:
          route = AppRoutes.ngoHome;
      }

      Navigator.pushReplacementNamed(context, route);
    } catch (e) {
      setState(() {
        _errorMessage = localizations?.invalidCredentials ??
            'Login failed. Please check your email and password.';
      });
      HapticFeedback.heavyImpact();
    }

    setState(() {
      _isLoading = false;
    });
  }

  /// 🔐 REAL BACKEND REGISTER
  Future<void> _onRegister(String name, String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

      final roleUpper = _selectedRole.toUpperCase(); // NGO, ADMIN, COMPANY
      final response = await dio.post('/auth/register', data: {
        "name": name,
        "email": email,
        "password": password,
        "role": roleUpper,
      });

      final data = response.data;
      final token = data['token'];
      final user = data['user'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', user['role']);
      await prefs.setString('auth_token', token);

      HapticFeedback.lightImpact();

      String route;
      switch (user['role']) {
        case 'NGO':
          route = AppRoutes.ngoHome;
          break;
        case 'ADMIN':
          route = AppRoutes.adminDashboard;
          break;
        case 'COMPANY':
          route = AppRoutes.carbonCreditMarketplace;
          break;
        default:
          route = AppRoutes.ngoHome;
      }

      Navigator.pushReplacementNamed(context, route);
    } catch (e) {
      setState(() {
        _errorMessage = 'Registration failed. Please try again.';
      });
      HapticFeedback.heavyImpact();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onRoleChanged(String role) {
    setState(() {
      _selectedRole = role;
      _errorMessage = null;
    });
  }

  void _onForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Forgot password feature will be available soon'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Language Picker
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LanguagePickerWidget(
                      selectedLanguage: _selectedLanguage,
                      onLanguageChanged: _onLanguageChanged,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                // App Logo
                Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'eco',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 10.w,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          localizations?.appName ?? 'Vsmart',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4.h),

                // Welcome Text
                Text(
                  localizations?.welcomeBack ?? 'Welcome Back',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  localizations?.signInToContinue ??
                      'Sign in to continue to your environmental projects',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),

                // Role Selection
                RoleSelectionWidget(
                  selectedRole: _selectedRole,
                  onRoleChanged: _onRoleChanged,
                ),
                SizedBox(height: 4.h),

                // Error Message
                if (_errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error.withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.error.withValues(
                          alpha: 0.3,
                        ),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'error',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),
                ],

                // Auth mode toggle
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () => setState(() => _isRegister = !_isRegister),
                    child: Text(
                      _isRegister
                          ? 'Have an account? Sign in'
                          : 'New here? Create account',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Auth Form
                if (_isRegister)
                  RegistrationFormWidget(
                    selectedRole: _selectedRole,
                    isLoading: _isLoading,
                    onRegister: (name, email, password) =>
                        _onRegister(name, email, password),
                  )
                else
                  LoginFormWidget(
                    selectedRole: _selectedRole,
                    onLogin: _onLogin,
                    onDemoLogin: (role) {
                      // quick auto-login with default accounts
                      if (role == 'ngo') {
                        _onLogin("ngo@test.com", "password123");
                      } else if (role == 'admin') {
                        _onLogin("admin@test.com", "password123");
                      } else if (role == 'company') {
                        _onLogin("company@test.com", "password123");
                      }
                    },
                    onForgotPassword: _onForgotPassword,
                    isLoading: _isLoading,
                  ),
                SizedBox(height: 4.h),

                // Footer
                Text(
                  'By signing in, you agree to our Terms of Service and Privacy Policy',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
