import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsDialogWidget extends StatelessWidget {
  final Map<String, dynamic> creditData;
  final VoidCallback onAddToWishlist;
  final VoidCallback onShare;
  final VoidCallback onCompare;

  const QuickActionsDialogWidget({
    Key? key,
    required this.creditData,
    required this.onAddToWishlist,
    required this.onShare,
    required this.onCompare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Project info
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: (creditData["thumbnail"] as String?) ?? "",
                    width: 15.w,
                    height: 15.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (creditData["projectName"] as String?) ??
                            "Unknown Project",
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        "${(creditData["creditAmount"] as int?) ?? 0} Credits • ₹${((creditData["creditAmount"] as int? ?? 0) * (creditData["pricePerCredit"] as double? ?? 0.0)).toStringAsFixed(2)}",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Action buttons
            Column(
              children: [
                _buildActionButton(
                  icon: 'favorite_border',
                  label: 'Add to Wishlist',
                  onTap: () {
                    Navigator.of(context).pop();
                    onAddToWishlist();
                  },
                ),
                SizedBox(height: 1.h),
                _buildActionButton(
                  icon: 'share',
                  label: 'Share Project',
                  onTap: () {
                    Navigator.of(context).pop();
                    onShare();
                  },
                ),
                SizedBox(height: 1.h),
                _buildActionButton(
                  icon: 'compare_arrows',
                  label: 'Add to Compare',
                  onTap: () {
                    Navigator.of(context).pop();
                    onCompare();
                  },
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Cancel button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.primaryLight,
              size: 24,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textPrimaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
