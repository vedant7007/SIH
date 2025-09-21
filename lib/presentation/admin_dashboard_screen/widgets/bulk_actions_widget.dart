import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BulkActionsWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onBulkApprove;
  final VoidCallback onBulkReject;
  final VoidCallback onClearSelection;

  const BulkActionsWidget({
    Key? key,
    required this.selectedCount,
    required this.onBulkApprove,
    required this.onBulkReject,
    required this.onClearSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedCount == 0) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'check_box',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              '$selectedCount project${selectedCount > 1 ? 's' : ''} selected',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildBulkActionButton(
            icon: 'check',
            label: 'Approve',
            color: AppTheme.lightTheme.colorScheme.primary,
            onTap: onBulkApprove,
          ),
          SizedBox(width: 2.w),
          _buildBulkActionButton(
            icon: 'close',
            label: 'Reject',
            color: AppTheme.lightTheme.colorScheme.error,
            onTap: onBulkReject,
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: onClearSelection,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'clear',
                color: AppTheme.lightTheme.colorScheme.outline,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulkActionButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
