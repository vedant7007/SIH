import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectBottomSheet extends StatefulWidget {
  final Map<String, dynamic> project;
  final VoidCallback onClose;
  final VoidCallback onViewFullDetails;

  const ProjectBottomSheet({
    Key? key,
    required this.project,
    required this.onClose,
    required this.onViewFullDetails,
  }) : super(key: key);

  @override
  State<ProjectBottomSheet> createState() => _ProjectBottomSheetState();
}

class _ProjectBottomSheetState extends State<ProjectBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _closeBottomSheet() {
    _animationController.reverse().then((_) {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String status = (widget.project['status'] as String?) ?? 'pending';
    final Color statusColor = _getStatusColor(status);
    final List<String> images = (widget.project['images'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _slideAnimation.value) * 50.h),
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle Bar
                Container(
                  margin: EdgeInsets.only(top: 2.h),
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.dividerLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding: EdgeInsets.fromLTRB(4.w, 2.h, 2.w, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Project Information',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _closeBottomSheet,
                        icon: CustomIconWidget(
                          iconName: 'close',
                          color: AppTheme.textSecondaryLight,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Project Title and Status
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                (widget.project['title'] as String?) ??
                                    'Untitled Project',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: statusColor.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                status.toUpperCase(),
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 2.h),

                        // Project Description
                        Text(
                          (widget.project['description'] as String?) ??
                              'This environmental project focuses on carbon reduction and sustainable practices in the local community.',
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 3.h),

                        // Project Details Grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                icon: 'eco',
                                title: 'Carbon Credits',
                                value: '${widget.project['credits'] ?? 0}',
                                subtitle: 'CO₂ tons',
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: _buildInfoCard(
                                icon: 'attach_money',
                                title: 'Value',
                                value: '₹${widget.project['value'] ?? 0}',
                                subtitle: 'per credit',
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 2.h),

                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                icon: 'location_on',
                                title: 'Location',
                                value:
                                    (widget.project['location'] as String?) ??
                                        'Unknown',
                                subtitle: 'Project site',
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: _buildInfoCard(
                                icon: 'calendar_today',
                                title: 'Submitted',
                                value: _formatDate(
                                    widget.project['submittedDate']),
                                subtitle: 'Date',
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 3.h),

                        // Project Images
                        if (images.isNotEmpty) ...[
                          Text(
                            'Project Images',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          SizedBox(
                            height: 12.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length > 3 ? 3 : images.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 2.w),
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CustomImageWidget(
                                    imageUrl: images[index],
                                    width: 20.w,
                                    height: 12.h,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 3.h),
                        ],

                        // View Full Details Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: widget.onViewFullDetails,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                            ),
                            child: Text('View Full Details'),
                          ),
                        ),

                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required String icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border.all(color: AppTheme.dividerLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: AppTheme.primaryLight,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
