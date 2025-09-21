import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GpsOverlayWidget extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final double? accuracy;
  final bool isLoading;
  final VoidCallback onRefresh;

  const GpsOverlayWidget({
    Key? key,
    this.latitude,
    this.longitude,
    this.accuracy,
    required this.isLoading,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8.h,
      left: 4.w,
      right: 4.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'location_on',
              color: _getAccuracyColor(),
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLoading ? 'Getting location...' : _getLocationText(),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isLoading && accuracy != null)
                    Text(
                      'Accuracy: ${accuracy!.toStringAsFixed(1)}m',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 10.sp,
                      ),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onRefresh,
              child: Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'refresh',
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocationText() {
    if (latitude == null || longitude == null) {
      return 'Location unavailable';
    }
    return '${latitude!.toStringAsFixed(6)}, ${longitude!.toStringAsFixed(6)}';
  }

  Color _getAccuracyColor() {
    if (accuracy == null) return Colors.grey;
    if (accuracy! <= 5) return AppTheme.lightTheme.primaryColor;
    if (accuracy! <= 10) return AppTheme.accentLight;
    return AppTheme.errorLight;
  }
}
