import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum UserRole { ngo, admin, company }

class RoleBasedActionsWidget extends StatelessWidget {
  final UserRole userRole;
  final String projectStatus;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onShare;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onRequestInfo;
  final VoidCallback? onPurchaseCredits;

  const RoleBasedActionsWidget({
    Key? key,
    required this.userRole,
    required this.projectStatus,
    this.onEdit,
    this.onDuplicate,
    this.onShare,
    this.onApprove,
    this.onReject,
    this.onRequestInfo,
    this.onPurchaseCredits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (userRole) {
      case UserRole.ngo:
        return _buildNGOActions();
      case UserRole.admin:
        return _buildAdminActions();
      case UserRole.company:
        return _buildCompanyActions();
    }
  }

  Widget _buildNGOActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Actions',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            if (projectStatus.toLowerCase() == 'draft' ||
                projectStatus.toLowerCase() == 'rejected')
              Expanded(
                child: _buildActionButton(
                  label: 'Edit Project',
                  icon: 'edit',
                  onTap: onEdit,
                  isPrimary: true,
                ),
              ),
            if (projectStatus.toLowerCase() == 'draft' ||
                projectStatus.toLowerCase() == 'rejected')
              SizedBox(width: 3.w),
            Expanded(
              child: _buildActionButton(
                label: 'Duplicate',
                icon: 'content_copy',
                onTap: onDuplicate,
                isPrimary: false,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildActionButton(
                label: 'Share',
                icon: 'share',
                onTap: onShare,
                isPrimary: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdminActions() {
    final bool canApprove = projectStatus.toLowerCase() == 'pending' ||
        projectStatus.toLowerCase() == 'under_review';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Admin Actions',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        if (canApprove) ...[
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: 'Approve',
                  icon: 'check_circle',
                  onTap: onApprove,
                  isPrimary: true,
                  backgroundColor: AppTheme.successLight,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  label: 'Reject',
                  icon: 'cancel',
                  onTap: onReject,
                  isPrimary: false,
                  backgroundColor: AppTheme.errorLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildActionButton(
            label: 'Request More Information',
            icon: 'info',
            onTap: onRequestInfo,
            isPrimary: false,
            isFullWidth: true,
          ),
        ] else ...[
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'This project has already been processed. Status: ${projectStatus.toUpperCase()}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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

  Widget _buildCompanyActions() {
    final bool canPurchase = projectStatus.toLowerCase() == 'approved' ||
        projectStatus.toLowerCase() == 'verified';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Carbon Credits',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        if (canPurchase) ...[
          _buildActionButton(
            label: 'Purchase Carbon Credits',
            icon: 'shopping_cart',
            onTap: onPurchaseCredits,
            isPrimary: true,
            isFullWidth: true,
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.successLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.successLight.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'verified',
                  size: 24,
                  color: AppTheme.successLight,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verified Project',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.successLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'This project has been verified and carbon credits are available for purchase.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'hourglass_empty',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Credits Not Available',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Carbon credits will be available once the project is verified and approved.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required String icon,
    required VoidCallback? onTap,
    required bool isPrimary,
    bool isFullWidth = false,
    Color? backgroundColor,
  }) {
    final Color buttonColor = backgroundColor ??
        (isPrimary
            ? AppTheme.lightTheme.colorScheme.primary
            : AppTheme.lightTheme.colorScheme.surface);
    final Color textColor = isPrimary
        ? AppTheme.lightTheme.colorScheme.onPrimary
        : (backgroundColor ?? AppTheme.lightTheme.colorScheme.onSurface);

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          elevation: isPrimary ? 2 : 0,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: !isPrimary
                ? BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  )
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 18,
              color: textColor,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
