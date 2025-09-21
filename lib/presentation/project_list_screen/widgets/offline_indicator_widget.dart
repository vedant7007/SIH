import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OfflineIndicatorWidget extends StatelessWidget {
  final bool isOffline;
  final String? lastSyncTime;

  const OfflineIndicatorWidget({
    super.key,
    required this.isOffline,
    this.lastSyncTime,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: Colors.orange.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'cloud_off',
            size: 20,
            color: Colors.orange,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Viewing cached data',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (lastSyncTime != null)
                  Text(
                    'Last sync: $lastSyncTime',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange[700],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
