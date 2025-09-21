import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectCardWidget extends StatelessWidget {
  final Map<String, dynamic> project;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onViewDetails;
  final VoidCallback onAssignReviewer;
  final VoidCallback onSetPriority;
  final VoidCallback onRequestMoreInfo;
  final bool isSelected;
  final VoidCallback? onLongPress;

  const ProjectCardWidget({
    Key? key,
    required this.project,
    required this.onApprove,
    required this.onReject,
    required this.onViewDetails,
    required this.onAssignReviewer,
    required this.onSetPriority,
    required this.onRequestMoreInfo,
    this.isSelected = false,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final aiScore = (project['aiScore'] as double?) ?? 0.0;
    final isPriority = (project['isPriority'] as bool?) ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(project['id']),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onAssignReviewer(),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
              icon: Icons.person_add,
              label: 'Assign',
            ),
            SlidableAction(
              onPressed: (_) => onSetPriority(),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
              icon: Icons.flag,
              label: 'Priority',
            ),
            SlidableAction(
              onPressed: (_) => onRequestMoreInfo(),
              backgroundColor: AppTheme.lightTheme.colorScheme.outline,
              foregroundColor: AppTheme.lightTheme.colorScheme.surface,
              icon: Icons.info_outline,
              label: 'Info',
            ),
          ],
        ),
        child: GestureDetector(
          onLongPress: onLongPress,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: project['thumbnail'] as String? ?? '',
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
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  project['title'] as String? ??
                                      'Untitled Project',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              if (isPriority)
                                Container(
                                  padding: EdgeInsets.all(1.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme.lightTheme.colorScheme.error
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'flag',
                                    color:
                                        AppTheme.lightTheme.colorScheme.error,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'By ${project['ngoName'] as String? ?? 'Unknown NGO'}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Submitted: ${project['submissionDate'] as String? ?? 'Unknown'}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getAIScoreColor(aiScore).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'psychology',
                            color: _getAIScoreColor(aiScore),
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'AI: ${(aiScore * 100).toInt()}%',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: _getAIScoreColor(aiScore),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    _buildActionButton(
                      icon: 'check',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      onTap: onApprove,
                    ),
                    SizedBox(width: 2.w),
                    _buildActionButton(
                      icon: 'close',
                      color: AppTheme.lightTheme.colorScheme.error,
                      onTap: onReject,
                    ),
                    SizedBox(width: 2.w),
                    _buildActionButton(
                      icon: 'visibility',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      onTap: onViewDetails,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }

  Color _getAIScoreColor(double score) {
    if (score >= 0.8) {
      return AppTheme.lightTheme.colorScheme.primary;
    } else if (score >= 0.6) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }
}
