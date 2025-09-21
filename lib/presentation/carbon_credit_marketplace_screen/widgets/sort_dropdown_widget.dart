import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SortDropdownWidget extends StatelessWidget {
  final String selectedSort;
  final Function(String) onSortChanged;

  const SortDropdownWidget({
    Key? key,
    required this.selectedSort,
    required this.onSortChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      'Price Low-High',
      'Price High-Low',
      'Newest',
      'Most Popular',
      'Location',
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.dividerLight),
      ),
      child: DropdownButton<String>(
        value: selectedSort,
        onChanged: (String? newValue) {
          if (newValue != null) {
            onSortChanged(newValue);
          }
        },
        items: sortOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimaryLight,
              ),
            ),
          );
        }).toList(),
        icon: CustomIconWidget(
          iconName: 'keyboard_arrow_down',
          color: AppTheme.textSecondaryLight,
          size: 20,
        ),
        underline: SizedBox.shrink(),
        isExpanded: false,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.textPrimaryLight,
        ),
        dropdownColor: AppTheme.lightTheme.colorScheme.surface,
      ),
    );
  }
}
