import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BulkActionToolbarWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback? onDeleteSelected;
  final VoidCallback? onArchiveSelected;
  final VoidCallback? onExportSelected;
  final VoidCallback? onClearSelection;

  const BulkActionToolbarWidget({
    super.key,
    required this.selectedCount,
    this.onDeleteSelected,
    this.onArchiveSelected,
    this.onExportSelected,
    this.onClearSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          children: [
            IconButton(
              onPressed: onClearSelection,
              icon: CustomIconWidget(
                iconName: 'close',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              '$selectedCount selected',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: onExportSelected,
                  icon: CustomIconWidget(
                    iconName: 'file_download',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  tooltip: 'Export Selected',
                ),
                SizedBox(width: 1.w),
                IconButton(
                  onPressed: onArchiveSelected,
                  icon: CustomIconWidget(
                    iconName: 'archive',
                    size: 24,
                    color: Colors.orange,
                  ),
                  tooltip: 'Archive Selected',
                ),
                SizedBox(width: 1.w),
                IconButton(
                  onPressed: onDeleteSelected,
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                  tooltip: 'Delete Selected',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
