import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectCardWidget extends StatelessWidget {
  final Map<String, dynamic> project;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onShare;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;
  final bool isSelected;
  final bool isMultiSelectMode;
  final ValueChanged<bool?>? onSelectionChanged;

  const ProjectCardWidget({
    super.key,
    required this.project,
    this.onTap,
    this.onEdit,
    this.onDuplicate,
    this.onShare,
    this.onArchive,
    this.onDelete,
    this.isSelected = false,
    this.isMultiSelectMode = false,
    this.onSelectionChanged,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'pending':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'under review':
        return Colors.orange;
      case 'rejected':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(project['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onEdit?.call(),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onDuplicate?.call(),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.copy,
              label: 'Duplicate',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onShare?.call(),
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onArchive?.call(),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: 'Archive',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDelete?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: isMultiSelectMode
                ? () => onSelectionChanged?.call(!isSelected)
                : onTap,
            onLongPress: () => onSelectionChanged?.call(!isSelected),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  if (isMultiSelectMode) ...[
                    Checkbox(
                      value: isSelected,
                      onChanged: onSelectionChanged,
                    ),
                    SizedBox(width: 2.w),
                  ],
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: project['thumbnail'] as String? ??
                          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
                      width: 15.w,
                      height: 15.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project['title'] as String? ?? 'Untitled Project',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'location_on',
                              size: 16,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Text(
                                project['location'] as String? ??
                                    'Unknown Location',
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'calendar_today',
                              size: 16,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              project['submissionDate'] as String? ??
                                  'Unknown Date',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                              project['status'] as String? ?? 'pending')
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      project['status'] as String? ?? 'Pending',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getStatusColor(
                            project['status'] as String? ?? 'pending'),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
