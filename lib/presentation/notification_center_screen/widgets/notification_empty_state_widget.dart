import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationEmptyStateWidget extends StatelessWidget {
  final String filterType;
  final VoidCallback? onEnableNotifications;

  const NotificationEmptyStateWidget({
    Key? key,
    required this.filterType,
    this.onEnableNotifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: _getEmptyStateIcon(),
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20.w,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              _getEmptyStateTitle(),
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              _getEmptyStateDescription(),
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (filterType == 'All' && onEnableNotifications != null) ...[
              SizedBox(height: 4.h),
              ElevatedButton.icon(
                onPressed: onEnableNotifications,
                icon: CustomIconWidget(
                  iconName: 'notifications_active',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 5.w,
                ),
                label: Text(
                  'Enable Notifications',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
            if (filterType != 'All') ...[
              SizedBox(height: 3.h),
              TextButton(
                onPressed: () {
                  // Navigate back to All notifications
                },
                child: Text(
                  'View All Notifications',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getEmptyStateIcon() {
    switch (filterType) {
      case 'Unread':
        return 'mark_email_read';
      case 'Project Related':
        return 'eco';
      case 'System Messages':
        return 'settings';
      default:
        return 'notifications_none';
    }
  }

  String _getEmptyStateTitle() {
    switch (filterType) {
      case 'Unread':
        return 'All Caught Up!';
      case 'Project Related':
        return 'No Project Updates';
      case 'System Messages':
        return 'No System Messages';
      default:
        return 'No Notifications Yet';
    }
  }

  String _getEmptyStateDescription() {
    switch (filterType) {
      case 'Unread':
        return 'You\'ve read all your notifications. Great job staying on top of things!';
      case 'Project Related':
        return 'No project-related notifications at the moment. Check back later for updates on your environmental projects.';
      case 'System Messages':
        return 'No system messages right now. We\'ll notify you of any important system updates or maintenance.';
      default:
        return 'Stay connected with your carbon credit projects and marketplace activities. Enable notifications to get real-time updates.';
    }
  }
}
