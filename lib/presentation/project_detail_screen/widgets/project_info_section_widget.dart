import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectInfoSectionWidget extends StatelessWidget {
  final String title;
  final String location;
  final String submissionDate;
  final String status;
  final String description;

  const ProjectInfoSectionWidget({
    Key? key,
    required this.title,
    required this.location,
    required this.submissionDate,
    required this.status,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),

        // Location and Date
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'location_on',
                    size: 16,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 1.w),
                  Expanded(
                    child: Text(
                      location,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  size: 16,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 1.w),
                Text(
                  submissionDate,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 2.h),

        // Description Section
        _ExpandableDescriptionWidget(description: description),
      ],
    );
  }
}

class _ExpandableDescriptionWidget extends StatefulWidget {
  final String description;

  const _ExpandableDescriptionWidget({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  State<_ExpandableDescriptionWidget> createState() =>
      _ExpandableDescriptionWidgetState();
}

class _ExpandableDescriptionWidgetState
    extends State<_ExpandableDescriptionWidget> {
  bool _isExpanded = false;
  final int _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    final bool isLongText = widget.description.length > 150;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        AnimatedCrossFade(
          firstChild: Text(
            widget.description,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              height: 1.5,
            ),
            maxLines: _maxLines,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(
            widget.description,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              height: 1.5,
            ),
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
        ),
        if (isLongText) ...[
          SizedBox(height: 1.h),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              children: [
                Text(
                  _isExpanded ? 'Read Less' : 'Read More',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 1.w),
                CustomIconWidget(
                  iconName:
                      _isExpanded ? 'keyboard_arrow_up' : 'keyboard_arrow_down',
                  size: 16,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
