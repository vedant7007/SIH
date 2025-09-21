import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionButtonsWidget extends StatefulWidget {
  final VoidCallback onCameraPressed;
  final VoidCallback onAddPressed;
  final VoidCallback onSyncPressed;
  final bool isSyncing;
  final double syncProgress;

  const QuickActionButtonsWidget({
    Key? key,
    required this.onCameraPressed,
    required this.onAddPressed,
    required this.onSyncPressed,
    this.isSyncing = false,
    this.syncProgress = 0.0,
  }) : super(key: key);

  @override
  State<QuickActionButtonsWidget> createState() =>
      _QuickActionButtonsWidgetState();
}

class _QuickActionButtonsWidgetState extends State<QuickActionButtonsWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isSyncing) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(QuickActionButtonsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSyncing && !oldWidget.isSyncing) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isSyncing && oldWidget.isSyncing) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 4.w,
      bottom: 12.h,
      child: Column(
        children: [
          _buildActionButton(
            icon: 'camera_alt',
            onPressed: widget.onCameraPressed,
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            iconColor: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
          SizedBox(height: 2.h),
          _buildActionButton(
            icon: 'add',
            onPressed: widget.onAddPressed,
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            iconColor: AppTheme.lightTheme.colorScheme.onSecondary,
          ),
          SizedBox(height: 2.h),
          _buildSyncButton(),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      width: 14.w,
      height: 14.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(7.w),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              size: 24,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSyncButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isSyncing ? _pulseAnimation.value : 1.0,
          child: Container(
            width: 14.w,
            height: 14.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onSyncPressed,
                borderRadius: BorderRadius.circular(7.w),
                child: Stack(
                  children: [
                    Center(
                      child: widget.isSyncing
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                value: widget.syncProgress > 0
                                    ? widget.syncProgress
                                    : null,
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.onTertiary,
                                ),
                              ),
                            )
                          : CustomIconWidget(
                              iconName: 'sync',
                              size: 24,
                              color: AppTheme.lightTheme.colorScheme.onTertiary,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
