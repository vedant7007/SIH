import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectTitleFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String? errorText;
  final int maxLength;

  const ProjectTitleFieldWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.errorText,
    this.maxLength = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Project Title',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 1.w),
            Text(
              '*',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: 'Enter project title...',
            errorText: errorText,
            counterText: '${controller.text.length}/$maxLength',
            counterStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: controller.text.length > maxLength * 0.8
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'title',
                color: errorText != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
          ),
          style: AppTheme.lightTheme.textTheme.bodyLarge,
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }
}
