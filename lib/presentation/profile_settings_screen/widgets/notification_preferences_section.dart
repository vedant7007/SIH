import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationPreferencesSection extends StatefulWidget {
  final Map<String, bool> preferences;
  final Function(String, bool) onPreferenceChanged;

  const NotificationPreferencesSection({
    Key? key,
    required this.preferences,
    required this.onPreferenceChanged,
  }) : super(key: key);

  @override
  State<NotificationPreferencesSection> createState() =>
      _NotificationPreferencesSectionState();
}

class _NotificationPreferencesSectionState
    extends State<NotificationPreferencesSection> {
  late Map<String, bool> currentPreferences;

  final List<Map<String, String>> notificationTypes = [
    {
      'key': 'project_updates',
      'title': 'Project Updates',
      'subtitle': 'Notifications about project status changes',
      'icon': 'notifications_active',
    },
    {
      'key': 'system_alerts',
      'title': 'System Alerts',
      'subtitle': 'Important system notifications and maintenance',
      'icon': 'warning',
    },
    {
      'key': 'marketing',
      'title': 'Marketing Communications',
      'subtitle': 'Promotional content and feature announcements',
      'icon': 'campaign',
    },
    {
      'key': 'push_notifications',
      'title': 'Push Notifications',
      'subtitle': 'Master switch for all push notifications',
      'icon': 'mobile_friendly',
    },
  ];

  @override
  void initState() {
    super.initState();
    currentPreferences = Map.from(widget.preferences);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Text(
              'Notification Preferences',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: notificationTypes.map((notification) {
                final index = notificationTypes.indexOf(notification);
                return Column(
                  children: [
                    _buildNotificationTile(notification),
                    if (index < notificationTypes.length - 1)
                      Divider(
                        height: 1,
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.1),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, String> notification) {
    final key = notification['key']!;
    final isEnabled = currentPreferences[key] ?? false;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: isEnabled
                  ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: notification['icon']!,
              color: isEnabled
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title']!,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  notification['subtitle']!,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          Switch(
            value: isEnabled,
            onChanged: (value) {
              setState(() {
                currentPreferences[key] = value;
              });
              widget.onPreferenceChanged(key, value);
            },
            activeColor: AppTheme.lightTheme.primaryColor,
            inactiveThumbColor: AppTheme.lightTheme.colorScheme.outline,
            inactiveTrackColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
