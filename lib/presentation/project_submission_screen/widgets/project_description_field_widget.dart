import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectDescriptionFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String? errorText;
  final int maxLength;

  const ProjectDescriptionFieldWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.errorText,
    this.maxLength = 500,
  }) : super(key: key);

  @override
  State<ProjectDescriptionFieldWidget> createState() =>
      _ProjectDescriptionFieldWidgetState();
}

class _ProjectDescriptionFieldWidgetState
    extends State<ProjectDescriptionFieldWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Project Description',
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
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          child: TextFormField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            maxLength: widget.maxLength,
            minLines: _isExpanded ? 6 : 3,
            maxLines: _isExpanded ? 10 : 5,
            decoration: InputDecoration(
              hintText: 'Describe your environmental project in detail...',
              errorText: widget.errorText,
              counterText:
                  '${widget.controller.text.length}/${widget.maxLength}',
              counterStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: widget.controller.text.length > widget.maxLength * 0.8
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 3.w, right: 2.w, top: 3.w),
                child: CustomIconWidget(
                  iconName: 'description',
                  color: widget.errorText != null
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                ),
              ),
            ),
            style: AppTheme.lightTheme.textTheme.bodyLarge,
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
      ],
    );
  }
}
