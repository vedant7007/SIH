import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SortOptionsWidget extends StatelessWidget {
  final String currentSort;
  final Function(String) onSortChanged;

  const SortOptionsWidget({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      {'key': 'recent', 'label': 'Recent', 'icon': 'schedule'},
      {'key': 'alphabetical', 'label': 'Alphabetical', 'icon': 'sort_by_alpha'},
      {'key': 'status', 'label': 'Status', 'icon': 'flag'},
      {'key': 'location', 'label': 'Location', 'icon': 'location_on'},
    ];

    return PopupMenuButton<String>(
      onSelected: onSortChanged,
      icon: CustomIconWidget(
        iconName: 'sort',
        size: 24,
        color: AppTheme.lightTheme.colorScheme.onSurface,
      ),
      itemBuilder: (context) => sortOptions.map((option) {
        final isSelected = currentSort == option['key'];
        return PopupMenuItem<String>(
          value: option['key'] as String,
          child: Row(
            children: [
              CustomIconWidget(
                iconName: option['icon'] as String,
                size: 20,
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 3.w),
              Text(
                option['label'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                CustomIconWidget(
                  iconName: 'check',
                  size: 16,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
