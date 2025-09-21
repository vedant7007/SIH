import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationSectionWidget extends StatelessWidget {
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final TextEditingController addressController;
  final bool isGpsEnabled;
  final bool isLoadingLocation;
  final VoidCallback onGetCurrentLocation;
  final VoidCallback onToggleManualEntry;
  final Function(String) onLatitudeChanged;
  final Function(String) onLongitudeChanged;
  final Function(String) onAddressChanged;
  final String? locationError;

  const LocationSectionWidget({
    Key? key,
    required this.latitudeController,
    required this.longitudeController,
    required this.addressController,
    required this.isGpsEnabled,
    required this.isLoadingLocation,
    required this.onGetCurrentLocation,
    required this.onToggleManualEntry,
    required this.onLatitudeChanged,
    required this.onLongitudeChanged,
    required this.onAddressChanged,
    this.locationError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Project Location',
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
        SizedBox(height: 2.h),

        // GPS Auto-capture Section
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isGpsEnabled
                ? AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isGpsEnabled
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.dividerColor,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: isGpsEnabled ? 'gps_fixed' : 'gps_off',
                    color: isGpsEnabled
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isGpsEnabled
                              ? 'GPS Location Active'
                              : 'GPS Location Disabled',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: isGpsEnabled
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          isGpsEnabled
                              ? 'Location will be captured automatically'
                              : 'Enable GPS for automatic location capture',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isLoadingLocation ? null : onGetCurrentLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onPrimary,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoadingLocation
                        ? SizedBox(
                            width: 4.w,
                            height: 4.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'my_location',
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                size: 4.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Get Location',
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Manual Entry Toggle
        GestureDetector(
          onTap: onToggleManualEntry,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.dividerColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'edit_location',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Manual Location Entry',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                CustomIconWidget(
                  iconName: 'arrow_forward_ios',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Coordinate Fields
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: latitudeController,
                onChanged: onLatitudeChanged,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Latitude',
                  hintText: '0.000000',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'place',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                ),
                style:
                    AppTheme.getDataTextStyle(isLight: true, fontSize: 14.sp),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: TextFormField(
                controller: longitudeController,
                onChanged: onLongitudeChanged,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Longitude',
                  hintText: '0.000000',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'place',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                ),
                style:
                    AppTheme.getDataTextStyle(isLight: true, fontSize: 14.sp),
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Address Field
        TextFormField(
          controller: addressController,
          onChanged: onAddressChanged,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'Address',
            hintText: 'Enter project address...',
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 3.w, right: 2.w, top: 3.w),
              child: CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
          ),
          style: AppTheme.lightTheme.textTheme.bodyLarge,
          textCapitalization: TextCapitalization.words,
        ),

        if (locationError != null) ...[
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'error',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    locationError!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
