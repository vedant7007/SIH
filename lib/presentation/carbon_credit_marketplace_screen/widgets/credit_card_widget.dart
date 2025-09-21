import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CreditCardWidget extends StatelessWidget {
  final Map<String, dynamic> creditData;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const CreditCardWidget({
    Key? key,
    required this.creditData,
    required this.onAddToCart,
    required this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project thumbnail
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: CustomImageWidget(
                imageUrl: (creditData["thumbnail"] as String?) ?? "",
                width: double.infinity,
                height: 20.h,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project name
                  Text(
                    (creditData["projectName"] as String?) ?? "Unknown Project",
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 1.h),

                  // Location and verification date
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: AppTheme.textSecondaryLight,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          (creditData["location"] as String?) ??
                              "Unknown Location",
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 0.5.h),

                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'verified',
                        color: AppTheme.successLight,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        "Verified ${(creditData["verificationDate"] as String?) ?? "N/A"}",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.successLight,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.5.h),

                  // Credit amount and price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${(creditData["creditAmount"] as int?) ?? 0} Credits",
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryLight,
                            ),
                          ),
                          Text(
                            "₹${(creditData["pricePerCredit"] as double?)?.toStringAsFixed(2) ?? "0.00"} per credit",
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "₹${((creditData["creditAmount"] as int? ?? 0) * (creditData["pricePerCredit"] as double? ?? 0.0)).toStringAsFixed(2)}",
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  // Certification badges
                  if ((creditData["certifications"] as List?)?.isNotEmpty ==
                      true)
                    Wrap(
                      spacing: 1.w,
                      runSpacing: 0.5.h,
                      children: ((creditData["certifications"] as List?) ?? [])
                          .map<Widget>((cert) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentLight
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  cert as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme.accentLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),

                  SizedBox(height: 1.5.h),

                  // Remaining credits and Add to Cart button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${(creditData["remainingCredits"] as int?) ?? 0} remaining",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: onAddToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryLight,
                          foregroundColor: AppTheme.onPrimaryLight,
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'add_shopping_cart',
                              color: AppTheme.onPrimaryLight,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              "Add to Cart",
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                color: AppTheme.onPrimaryLight,
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
          ],
        ),
      ),
    );
  }
}
