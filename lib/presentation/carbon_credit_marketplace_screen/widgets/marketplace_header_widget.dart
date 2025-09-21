import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MarketplaceHeaderWidget extends StatelessWidget {
  final TextEditingController searchController;
  final int cartItemCount;
  final VoidCallback onCartTap;
  final Function(String) onSearchChanged;

  const MarketplaceHeaderWidget({
    Key? key,
    required this.searchController,
    required this.cartItemCount,
    required this.onCartTap,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      color: AppTheme.lightTheme.colorScheme.surface,
      child: Column(
        children: [
          // Search bar and cart icon
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.dividerLight),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      hintText: "Search credits, projects, locations...",
                      hintStyle:
                          AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textDisabledLight,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'search',
                          color: AppTheme.textSecondaryLight,
                          size: 20,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Cart icon with badge
              GestureDetector(
                onTap: onCartTap,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomIconWidget(
                        iconName: 'shopping_cart',
                        color: AppTheme.onPrimaryLight,
                        size: 24,
                      ),
                    ),
                    if (cartItemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: BoxDecoration(
                            color: AppTheme.errorLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 5.w,
                            minHeight: 5.w,
                          ),
                          child: Text(
                            cartItemCount > 99
                                ? '99+'
                                : cartItemCount.toString(),
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.onErrorLight,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
