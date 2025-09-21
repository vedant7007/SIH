import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectPreviewCard extends StatelessWidget {
  final Map<String, dynamic> project;
  final VoidCallback onViewDetails;
  final VoidCallback onClose;

  const ProjectPreviewCard({
    Key? key,
    required this.project,
    required this.onViewDetails,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String status = (project['status'] as String?) ?? 'pending';
    final Color statusColor = _getStatusColor(status);

    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 3.w, 2.w, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Project Details',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondaryLight,
                    size: 20,
                  ),
                  padding: EdgeInsets.all(1.w),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Project Content
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomImageWidget(
                    imageUrl: (project['thumbnail'] as String?) ??
                        'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
                    width: double.infinity,
                    height: 20.h,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(height: 3.h),

                // Project Title and Status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        (project['title'] as String?) ?? 'Untitled Project',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Project Details
                _buildDetailRow(
                  icon: 'location_on',
                  label: 'Location',
                  value: (project['location'] as String?) ?? 'Unknown Location',
                ),

                SizedBox(height: 1.h),

                _buildDetailRow(
                  icon: 'eco',
                  label: 'Credits',
                  value: '${project['credits'] ?? 0} CO₂ tons',
                ),

                SizedBox(height: 1.h),

                _buildDetailRow(
                  icon: 'calendar_today',
                  label: 'Submitted',
                  value: _formatDate(project['submittedDate']),
                ),

                SizedBox(height: 3.h),

                // View Details Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onViewDetails,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    child: Text('View Full Details'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.textSecondaryLight,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Text(
          '$label: ',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textPrimaryLight,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppTheme.successLight;
      case 'pending':
        return AppTheme.warningLight;
      case 'rejected':
        return AppTheme.errorLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Unknown';

    try {
      DateTime dateTime;
      if (date is String) {
        dateTime = DateTime.parse(date);
      } else if (date is DateTime) {
        dateTime = date;
      } else {
        return 'Unknown';
      }

      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return 'Unknown';
    }
  }
}
