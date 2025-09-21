import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/language_picker_section.dart';
import './widgets/notification_preferences_section.dart';
import './widgets/profile_photo_section.dart';
import './widgets/settings_group.dart';
import './widgets/settings_tile.dart';
import './widgets/theme_toggle_section.dart';
import './widgets/user_info_section.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "name": "Priya Sharma",
    "email": "priya.sharma@greenearth.org",
    "role": "NGO",
    "organization": "Green Earth Foundation",
    "profileImage":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
    "phone": "+91 98765 43210",
    "location": "Mumbai, Maharashtra",
    "joinDate": "2023-03-15",
    "projectsCompleted": 24,
    "carbonCreditsEarned": 1250,
  };

  // Settings state
  String currentTheme = 'system';
  String currentLanguage = 'en';
  Map<String, bool> notificationPreferences = {
    'project_updates': true,
    'system_alerts': true,
    'marketing': false,
    'push_notifications': true,
  };

  bool hasUnsavedChanges = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfilePhotoSection(
              profileImageUrl: userData["profileImage"],
              onPhotoTap: _handlePhotoUpdate,
            ),
            UserInfoSection(
              userName: userData["name"],
              userEmail: userData["email"],
              userRole: userData["role"],
              organization: userData["organization"],
              onEditTap: _handleEditProfile,
            ),
            SizedBox(height: 2.h),
            SettingsGroup(
              title: 'Account Settings',
              children: [
                SettingsTile(
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  iconName: 'lock',
                  onTap: _handleChangePassword,
                ),
                SettingsTile(
                  title: 'Two-Factor Authentication',
                  subtitle: 'Add extra security to your account',
                  iconName: 'security',
                  trailing: Switch(
                    value: true,
                    onChanged: _handleTwoFactorToggle,
                    activeColor: AppTheme.lightTheme.primaryColor,
                  ),
                  showArrow: false,
                ),
                SettingsTile(
                  title: 'Biometric Login',
                  subtitle: 'Use fingerprint or face ID',
                  iconName: 'fingerprint',
                  trailing: Switch(
                    value: false,
                    onChanged: _handleBiometricToggle,
                    activeColor: AppTheme.lightTheme.primaryColor,
                  ),
                  showArrow: false,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            ThemeToggleSection(
              currentTheme: currentTheme,
              onThemeChanged: _handleThemeChange,
            ),
            SizedBox(height: 1.h),
            LanguagePickerSection(
              currentLanguage: currentLanguage,
              onLanguageChanged: _handleLanguageChange,
            ),
            SizedBox(height: 1.h),
            NotificationPreferencesSection(
              preferences: notificationPreferences,
              onPreferenceChanged: _handleNotificationPreferenceChange,
            ),
            SizedBox(height: 1.h),
            SettingsGroup(
              title: 'Privacy Settings',
              children: [
                SettingsTile(
                  title: 'Data Sharing',
                  subtitle: 'Control how your data is shared',
                  iconName: 'share',
                  onTap: _handleDataSharing,
                ),
                SettingsTile(
                  title: 'Account Visibility',
                  subtitle: 'Manage who can see your profile',
                  iconName: 'visibility',
                  onTap: _handleAccountVisibility,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            SettingsGroup(
              title: 'Help & Support',
              children: [
                SettingsTile(
                  title: 'FAQ',
                  subtitle: 'Frequently asked questions',
                  iconName: 'help',
                  onTap: _handleFAQ,
                ),
                SettingsTile(
                  title: 'Contact Support',
                  subtitle: 'Get help from our team',
                  iconName: 'support_agent',
                  onTap: _handleContactSupport,
                ),
                SettingsTile(
                  title: 'Tutorial Replay',
                  subtitle: 'Watch the app tutorial again',
                  iconName: 'play_circle',
                  onTap: _handleTutorialReplay,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            SettingsGroup(
              title: 'About',
              children: [
                SettingsTile(
                  title: 'App Version',
                  subtitle: 'v1.2.3 (Build 45)',
                  iconName: 'info',
                  showArrow: false,
                ),
                SettingsTile(
                  title: 'Terms of Service',
                  subtitle: 'Read our terms and conditions',
                  iconName: 'description',
                  onTap: _handleTermsOfService,
                ),
                SettingsTile(
                  title: 'Privacy Policy',
                  subtitle: 'Learn about our privacy practices',
                  iconName: 'privacy_tip',
                  onTap: _handlePrivacyPolicy,
                ),
              ],
            ),
            SizedBox(height: 3.h),
            _buildLogoutButton(),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => _handleBackNavigation(),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 6.w,
        ),
      ),
      title: Text(
        'Profile Settings',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        if (hasUnsavedChanges) ...[
          TextButton(
            onPressed: _handleSaveChanges,
            child: Text(
              'Save',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ],
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          foregroundColor: AppTheme.lightTheme.colorScheme.onError,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'logout',
              color: AppTheme.lightTheme.colorScheme.onError,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Logout',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onError,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBackNavigation() {
    if (hasUnsavedChanges) {
      _showUnsavedChangesDialog();
    } else {
      Navigator.pop(context);
    }
  }

  void _handlePhotoUpdate() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Update Profile Photo',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _buildPhotoOption(
                    'Camera',
                    'camera_alt',
                    () => _selectPhotoFromCamera(),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildPhotoOption(
                    'Gallery',
                    'photo_library',
                    () => _selectPhotoFromGallery(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption(String title, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.primaryColor,
              size: 8.w,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectPhotoFromCamera() {
    Navigator.pop(context);
    // Navigate to camera capture screen
    Navigator.pushNamed(context, '/camera-capture-screen');
  }

  void _selectPhotoFromGallery() {
    Navigator.pop(context);
    // Implement gallery selection logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gallery selection feature coming soon'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleEditProfile() {
    // Navigate to edit profile screen or show edit dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit profile feature coming soon'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleChangePassword() {
    // Navigate to change password screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Change password feature coming soon'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleTwoFactorToggle(bool value) {
    setState(() {
      hasUnsavedChanges = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value
            ? 'Two-factor authentication enabled'
            : 'Two-factor authentication disabled'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleBiometricToggle(bool value) {
    setState(() {
      hasUnsavedChanges = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            value ? 'Biometric login enabled' : 'Biometric login disabled'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleThemeChange(String theme) {
    setState(() {
      currentTheme = theme;
      hasUnsavedChanges = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Theme changed to ${theme.toUpperCase()}'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleLanguageChange(String language) {
    setState(() {
      currentLanguage = language;
      hasUnsavedChanges = true;
    });
    final languageNames = {'en': 'English', 'hi': 'Hindi', 'te': 'Telugu'};
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Language changed to ${languageNames[language]}'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleNotificationPreferenceChange(String key, bool value) {
    setState(() {
      notificationPreferences[key] = value;
      hasUnsavedChanges = true;
    });
  }

  void _handleDataSharing() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data sharing settings coming soon'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleAccountVisibility() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Account visibility settings coming soon'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleFAQ() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('FAQ section coming soon'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleContactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contact support feature coming soon'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleTutorialReplay() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tutorial replay feature coming soon'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleTermsOfService() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Terms of service coming soon'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handlePrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Privacy policy coming soon'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleSaveChanges() {
    setState(() {
      hasUnsavedChanges = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings saved successfully'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Logout Confirmation',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to logout? Any unsaved changes will be lost.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/authentication-screen',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Unsaved Changes',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'You have unsaved changes. Do you want to save them before leaving?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'Discard',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleSaveChanges();
              Navigator.pop(context);
            },
            child: Text('Save & Exit'),
          ),
        ],
      ),
    );
  }
}
