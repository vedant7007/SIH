import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraControlsWidget extends StatelessWidget {
  final VoidCallback onCapture;
  final VoidCallback onGallery;
  final VoidCallback onFlashToggle;
  final VoidCallback onModeSwitch;
  final String? lastImagePath;
  final FlashMode flashMode;
  final bool isPhotoMode;
  final bool isRecording;

  const CameraControlsWidget({
    Key? key,
    required this.onCapture,
    required this.onGallery,
    required this.onFlashToggle,
    required this.onModeSwitch,
    this.lastImagePath,
    required this.flashMode,
    required this.isPhotoMode,
    required this.isRecording,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 20.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            _buildModeSelector(),
            SizedBox(height: 2.h),
            _buildControlButtons(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: isPhotoMode ? null : onModeSwitch,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: isPhotoMode
                  ? AppTheme.lightTheme.primaryColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Photo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: isPhotoMode ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
        SizedBox(width: 4.w),
        GestureDetector(
          onTap: !isPhotoMode ? null : onModeSwitch,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: !isPhotoMode
                  ? AppTheme.lightTheme.primaryColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Video',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: !isPhotoMode ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Gallery button
        GestureDetector(
          onTap: onGallery,
          child: Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: lastImagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomImageWidget(
                      imageUrl: lastImagePath!,
                      width: 15.w,
                      height: 15.w,
                      fit: BoxFit.cover,
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'photo_library',
                    color: Colors.white,
                    size: 24,
                  ),
          ),
        ),

        // Capture button
        GestureDetector(
          onTap: onCapture,
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: isRecording ? AppTheme.errorLight : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
            ),
            child: isRecording
                ? Container(
                    margin: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )
                : null,
          ),
        ),

        // Flash button (hidden on web)
        kIsWeb
            ? SizedBox(width: 15.w)
            : GestureDetector(
                onTap: onFlashToggle,
                child: Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: _getFlashIcon(),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
      ],
    );
  }

  String _getFlashIcon() {
    switch (flashMode) {
      case FlashMode.auto:
        return 'flash_auto';
      case FlashMode.always:
        return 'flash_on';
      case FlashMode.off:
        return 'flash_off';
      case FlashMode.torch:
        return 'flashlight_on';
    }
  }
}
