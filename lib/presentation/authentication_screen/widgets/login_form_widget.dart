import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  final String selectedRole;
  final Function(String email, String password) onLogin;
  final Function(String role) onDemoLogin;
  final VoidCallback onForgotPassword;
  final bool isLoading;

  const LoginFormWidget({
    Key? key,
    required this.selectedRole,
    required this.onLogin,
    required this.onDemoLogin,
    required this.onForgotPassword,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String? _emailError;
  String? _passwordError;

  // Demo credentials for each role (match backend seed users)
  final Map<String, Map<String, String>> _demoCredentials = {
    'ngo': {
      'email': 'ngo@test.com',
      'password': 'password123',
    },
    'admin': {
      'email': 'admin@test.com',
      'password': 'password123',
    },
    'company': {
      'email': 'company@test.com',
      'password': 'password123',
    },
  };

  bool get _isFormValid {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _emailError == null &&
        _passwordError == null;
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = 'Email is required';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _emailError = 'Please enter a valid email';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'Password is required';
      } else if (value.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
      } else {
        _passwordError = null;
      }
    });
  }

  void _fillDemoCredentials() {
    final credentials = _demoCredentials[widget.selectedRole];
    if (credentials != null) {
      setState(() {
        _emailController.text = credentials['email']!;
        _passwordController.text = credentials['password']!;
        _emailError = null;
        _passwordError = null;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !widget.isLoading,
                onChanged: _validateEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'email',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                  errorText: null,
                ),
              ),
              if (_emailError != null) ...[
                SizedBox(height: 0.5.h),
                Padding(
                  padding: EdgeInsets.only(left: 3.w),
                  child: Text(
                    _emailError!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 2.h),

          // Password Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                enabled: !widget.isLoading,
                onChanged: _validatePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'lock',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: _isPasswordVisible
                            ? 'visibility'
                            : 'visibility_off',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                    ),
                  ),
                  errorText: null,
                ),
              ),
              if (_passwordError != null) ...[
                SizedBox(height: 0.5.h),
                Padding(
                  padding: EdgeInsets.only(left: 3.w),
                  child: Text(
                    _passwordError!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 1.h),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.isLoading ? null : widget.onForgotPassword,
              child: Text(
                'Forgot Password?',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Demo Account Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: widget.isLoading ? null : _fillDemoCredentials,
              icon: CustomIconWidget(
                iconName: 'science',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 4.w,
              ),
              label:
                  Text('Use Demo ${widget.selectedRole.toUpperCase()} Account'),
            ),
          ),
          SizedBox(height: 2.h),

          // Login Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_isFormValid && !widget.isLoading)
                  ? () => widget.onLogin(
                      _emailController.text, _passwordController.text)
                  : null,
              child: widget.isLoading
                  ? SizedBox(
                      height: 5.w,
                      width: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
