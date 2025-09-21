import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectTypePickerWidget extends StatelessWidget {
  final String? selectedType;
  final Function(String) onTypeSelected;
  final List<String> projectTypes;
  final String? errorText;

  const ProjectTypePickerWidget({
    Key? key,
    required this.selectedType,
    required this.onTypeSelected,
    required this.projectTypes,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Project Type',
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
        InkWell(
          onTap: () => _showProjectTypePicker(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: errorText != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.dividerColor,
                width: errorText != null ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: _getProjectTypeIcon(selectedType),
                  color: errorText != null
                      ? AppTheme.lightTheme.colorScheme.error
                      : selectedType != null
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    selectedType ?? 'Select project type...',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: selectedType != null
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: selectedType != null
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                  ),
                ),
                CustomIconWidget(
                  iconName: 'arrow_drop_down',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.only(left: 3.w),
            child: Text(
              errorText!,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showProjectTypePicker(BuildContext context) {
    // Use web-safe modal for all platforms or native pickers when available
    if (kIsWeb) {
      _showWebPicker(context);
    } else if (Platform.isIOS) {
      _showIOSPicker(context);
    } else {
      _showAndroidPicker(context);
    }
  }

  void _showWebPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Project Type',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: projectTypes.length,
              itemBuilder: (context, index) {
                final type = projectTypes[index];
                final isSelected = selectedType == type;

                return ListTile(
                  leading: CustomIconWidget(
                    iconName: _getProjectTypeIcon(type),
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                  title: Text(
                    type,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  trailing: isSelected
                      ? CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 6.w,
                        )
                      : null,
                  onTap: () {
                    onTypeSelected(type);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showIOSPicker(BuildContext context) {
    int selectedIndex =
        selectedType != null ? projectTypes.indexOf(selectedType!) : 0;
    int tempIndex = selectedIndex;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 40.h,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator.resolveFrom(context),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: CupertinoColors.systemRed.resolveFrom(context),
                        ),
                      ),
                    ),
                    Text(
                      'Select Project Type',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label.resolveFrom(context),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (tempIndex >= 0 && tempIndex < projectTypes.length) {
                          onTypeSelected(projectTypes[tempIndex]);
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color:
                              CupertinoColors.activeBlue.resolveFrom(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 8.h,
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedIndex,
                  ),
                  onSelectedItemChanged: (int index) {
                    tempIndex = index;
                  },
                  children: projectTypes.map((String type) {
                    return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: _getProjectTypeIcon(type),
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 6.w,
                          ),
                          SizedBox(width: 3.w),
                          Flexible(
                            child: Text(
                              type,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color:
                                    CupertinoColors.label.resolveFrom(context),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAndroidPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'Select Project Type',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: projectTypes.length,
                  itemBuilder: (context, index) {
                    final type = projectTypes[index];
                    final isSelected = selectedType == type;

                    return ListTile(
                      leading: CustomIconWidget(
                        iconName: _getProjectTypeIcon(type),
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                      title: Text(
                        type,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      trailing: isSelected
                          ? CustomIconWidget(
                              iconName: 'check_circle',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 6.w,
                            )
                          : null,
                      onTap: () {
                        onTypeSelected(type);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  String _getProjectTypeIcon(String? type) {
    switch (type) {
      case 'Tree Plantation':
        return 'eco';
      case 'Mangrove Restoration':
        return 'water';
      case 'Forest Conservation':
        return 'forest';
      case 'Agroforestry':
        return 'agriculture';
      case 'Wetland Restoration':
        return 'nature';
      case 'Grassland Restoration':
        return 'grass';
      case 'Bamboo Cultivation':
        return 'eco';
      case 'Carbon Sequestration':
        return 'co2';
      case 'Soil Carbon Enhancement':
        return 'terrain';
      case 'Community Reforestation':
        return 'forest';
      default:
        return 'eco';
    }
  }
}
