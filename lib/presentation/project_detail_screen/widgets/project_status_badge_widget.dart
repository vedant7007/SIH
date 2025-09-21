import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectStatusBadgeWidget extends StatelessWidget {
  final String status;
  final bool isLarge;

  const ProjectStatusBadgeWidget({
    Key? key,
    required this.status,
    this.isLarge = false,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'verified':
      case 'completed':
        return AppTheme.successLight;
      case 'pending':
      case 'under_review':
      case 'in_review':
        return AppTheme.accentLight;
      case 'rejected':
      case 'failed':
        return AppTheme.errorLight;
      case 'draft':
      case 'submitted':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'verified':
      case 'completed':
        return 'check_circle';
      case 'pending':
      case 'under_review':
      case 'in_review':
        return 'schedule';
      case 'rejected':
      case 'failed':
        return 'cancel';
      case 'draft':
        return 'edit';
      case 'submitted':
        return 'upload';
      default:
        return 'info';
    }
  }

  String _getDisplayStatus() {
    switch (status.toLowerCase()) {
      case 'under_review':
      case 'in_review':
        return 'Under Review';
      case 'approved':
        return 'Approved';
      case 'verified':
        return 'Verified';
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending';
      case 'rejected':
        return 'Rejected';
      case 'failed':
        return 'Failed';
      case 'draft':
        return 'Draft';
      case 'submitted':
        return 'Submitted';
      default:
        return status.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final statusIcon = _getStatusIcon();
    final displayStatus = _getDisplayStatus();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 4.w : 3.w,
        vertical: isLarge ? 1.5.h : 1.h,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(isLarge ? 12 : 8),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: statusIcon,
            size: isLarge ? 20 : 16,
            color: statusColor,
          ),
          SizedBox(width: 1.w),
          Text(
            displayStatus,
            style: (isLarge
                    ? AppTheme.lightTheme.textTheme.titleSmall
                    : AppTheme.lightTheme.textTheme.bodySmall)
                ?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
