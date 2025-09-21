import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationCardWidget extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;
  final VoidCallback? onReply;
  final bool isSelected;
  final bool isMultiSelectMode;
  final ValueChanged<bool?>? onSelectionChanged;

  const NotificationCardWidget({
    Key? key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
    this.onArchive,
    this.onDelete,
    this.onReply,
    this.isSelected = false,
    this.isMultiSelectMode = false,
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isUnread = notification['isUnread'] ?? false;
    final bool isPriority = notification['isPriority'] ?? false;
    final String category = notification['category'] ?? '';
    final bool hasReplyAction =
        ['Project Updates', 'Verification Results'].contains(category);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(notification['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onMarkAsRead?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: Colors.white,
              icon: Icons.mark_email_read,
              label: 'Read',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onArchive?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: 'Archive',
              borderRadius: BorderRadius.circular(12),
            ),
            if (hasReplyAction)
              SlidableAction(
                onPressed: (_) => onReply?.call(),
                backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                foregroundColor: Colors.black,
                icon: Icons.reply,
                label: 'Reply',
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
        child: GestureDetector(
          onTap: isMultiSelectMode
              ? () => onSelectionChanged?.call(!isSelected)
              : onTap,
          onLongPress: () => onSelectionChanged?.call(!isSelected),
          child: Container(
            decoration: BoxDecoration(
              color: isPriority
                  ? AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isPriority
                    ? AppTheme.lightTheme.colorScheme.tertiary
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                width: isPriority ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isMultiSelectMode)
                    Container(
                      margin: EdgeInsets.only(right: 3.w),
                      child: Checkbox(
                        value: isSelected,
                        onChanged: onSelectionChanged,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  _buildAvatar(),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification['title'] ?? '',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: isUnread
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isUnread)
                              Container(
                                width: 2.w,
                                height: 2.w,
                                margin: EdgeInsets.only(left: 2.w),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          notification['sender'] ?? '',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          notification['preview'] ?? '',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildCategoryChip(category),
                            Text(
                              _formatTimestamp(notification['timestamp']),
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildAvatar() {
    final String? avatarUrl = notification['avatar'];
    final String category = notification['category'] ?? '';

    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getCategoryColor(category).withValues(alpha: 0.1),
      ),
      child: avatarUrl != null && avatarUrl.isNotEmpty
          ? ClipOval(
              child: CustomImageWidget(
                imageUrl: avatarUrl,
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              ),
            )
          : CustomIconWidget(
              iconName: _getCategoryIcon(category),
              color: _getCategoryColor(category),
              size: 6.w,
            ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: _getCategoryColor(category).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getCategoryColor(category).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        category,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: _getCategoryColor(category),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Project Updates':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'System Alerts':
        return AppTheme.lightTheme.colorScheme.error;
      case 'Verification Results':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'Marketplace Activity':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'Project Updates':
        return 'update';
      case 'System Alerts':
        return 'warning';
      case 'Verification Results':
        return 'verified';
      case 'Marketplace Activity':
        return 'shopping_cart';
      default:
        return 'notifications';
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';

    DateTime dateTime;
    if (timestamp is String) {
      dateTime = DateTime.tryParse(timestamp) ?? DateTime.now();
    } else if (timestamp is DateTime) {
      dateTime = timestamp;
    } else {
      return '';
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
