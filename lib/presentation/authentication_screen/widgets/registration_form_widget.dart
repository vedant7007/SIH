import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormWidget extends StatefulWidget {
  final String selectedRole;
  final Function(String name, String email, String password) onRegister;
  final bool isLoading;

  const RegistrationFormWidget({
    Key? key,
    required this.selectedRole,
    required this.onRegister,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  bool _isPasswordVisible = false;

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _nameError == null &&
        _emailError == null &&
        _passwordError == null;
  }

  void _validateName(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _nameError = 'Name is required';
      } else if (value.trim().length < 2) {
        _nameError = 'Please enter a valid name';
      } else {
        _nameError = null;
      }
    });
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = 'Email is required';
      } else if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(value)) {
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              enabled: !widget.isLoading,
              onChanged: _validateName,
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
                errorText: null,
              ),
            ),
            if (_nameError != null) ...[
              SizedBox(height: 0.5.h),
              Padding(
                padding: EdgeInsets.only(left: 3.w),
                child: Text(
                  _nameError!,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 2.h),

        // Email
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

        // Password
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
                hintText: 'Create a password',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'lock',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () => setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  }),
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName:
                          _isPasswordVisible ? 'visibility' : 'visibility_off',
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
        SizedBox(height: 3.h),

        // Register button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_isFormValid && !widget.isLoading)
                ? () => widget.onRegister(
                      _nameController.text.trim(),
                      _emailController.text.trim(),
                      _passwordController.text,
                    )
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
                : const Text('Create Account'),
          ),
        ),
      ],
    );
  }
}
