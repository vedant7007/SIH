import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickStatsWidget extends StatelessWidget {
  final int pendingReviews;
  final int approvedProjects;
  final int totalCreditsMinted;

  const QuickStatsWidget({
    Key? key,
    required this.pendingReviews,
    required this.approvedProjects,
    required this.totalCreditsMinted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Pending Reviews',
              pendingReviews.toString(),
              CustomIconWidget(
                iconName: 'pending_actions',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildStatCard(
              'Approved',
              approvedProjects.toString(),
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildStatCard(
              'Credits Minted',
              '${(totalCreditsMinted / 1000).toStringAsFixed(1)}K',
              CustomIconWidget(
                iconName: 'eco',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, Widget icon, Color backgroundColor) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              icon,
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
