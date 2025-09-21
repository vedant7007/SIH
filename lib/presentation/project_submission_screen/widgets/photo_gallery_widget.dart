import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoGalleryWidget extends StatelessWidget {
  final List<String> photos;
  final VoidCallback onAddPhoto;
  final Function(int) onRemovePhoto;
  final Function(int, int) onReorderPhotos;
  final bool isLoading;

  const PhotoGalleryWidget({
    Key? key,
    required this.photos,
    required this.onAddPhoto,
    required this.onRemovePhoto,
    required this.onReorderPhotos,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Project Photos',
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
            Spacer(),
            Text(
              '${photos.length}/10',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: photos.length >= 8
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          'Add photos to document your environmental project',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),

        // Photo Grid
        photos.isEmpty ? _buildEmptyState() : _buildPhotoGrid(),

        SizedBox(height: 2.h),

        // Add Photo Button
        GestureDetector(
          onTap: photos.length >= 10 || isLoading ? null : onAddPhoto,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: photos.length >= 10 || isLoading
                  ? AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.5)
                  : AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: photos.length >= 10 || isLoading
                    ? AppTheme.lightTheme.dividerColor.withValues(alpha: 0.5)
                    : AppTheme.lightTheme.colorScheme.primary,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 5.w,
                        height: 5.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Adding Photo...',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: photos.length >= 10 ? 'block' : 'add_a_photo',
                        color: photos.length >= 10
                            ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5)
                            : AppTheme.lightTheme.colorScheme.primary,
                        size: 6.w,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        photos.length >= 10
                            ? 'Maximum Photos Reached'
                            : 'Add Photo',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: photos.length >= 10
                              ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5)
                              : AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      height: 30.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'photo_library',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                .withValues(alpha: 0.5),
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No photos added yet',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Tap "Add Photo" to capture or select images',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return Container(
      height: 25.h,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        onReorder: onReorderPhotos,
        itemBuilder: (context, index) {
          return Container(
            key: ValueKey(photos[index]),
            margin: EdgeInsets.only(right: 3.w),
            child: Stack(
              children: [
                Container(
                  width: 35.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.dividerColor,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImageWidget(
                      imageUrl: photos[index],
                      width: 35.w,
                      height: 25.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Remove Button
                Positioned(
                  top: 1.w,
                  right: 1.w,
                  child: GestureDetector(
                    onTap: () => onRemovePhoto(index),
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.error,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow
                                .withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onError,
                        size: 4.w,
                      ),
                    ),
                  ),
                ),

                // Drag Handle
                Positioned(
                  bottom: 1.w,
                  right: 1.w,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.shadow
                              .withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomIconWidget(
                      iconName: 'drag_indicator',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 4.w,
                    ),
                  ),
                ),

                // Photo Index
                Positioned(
                  bottom: 1.w,
                  left: 1.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
