import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DomeGalleryWidget extends StatefulWidget {
  final List<Map<String, dynamic>> projects;
  final Function(Map<String, dynamic>) onProjectTap;
  final Function(Map<String, dynamic>) onProjectLongPress;

  const DomeGalleryWidget({
    Key? key,
    required this.projects,
    required this.onProjectTap,
    required this.onProjectLongPress,
  }) : super(key: key);

  @override
  State<DomeGalleryWidget> createState() => _DomeGalleryWidgetState();
}

class _DomeGalleryWidgetState extends State<DomeGalleryWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int? _pressedIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.projects.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      height: 50.h,
      child: Stack(
        children: [
          _buildDomeBackground(),
          _buildProjectPods(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 50.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'eco',
            size: 64,
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          SizedBox(height: 2.h),
          Text(
            'Start Your First Project',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Capture environmental projects and make a difference',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDomeBackground() {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectPods() {
    return Positioned.fill(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(4.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _buildProjectPod(widget.projects[index], index),
                childCount: widget.projects.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectPod(Map<String, dynamic> project, int index) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pressedIndex == index ? _scaleAnimation.value : 1.0,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() => _pressedIndex = index);
              _animationController.forward();
            },
            onTapUp: (_) {
              _animationController.reverse();
              setState(() => _pressedIndex = null);
              widget.onProjectTap(project);
            },
            onTapCancel: () {
              _animationController.reverse();
              setState(() => _pressedIndex = null);
            },
            onLongPress: () => widget.onProjectLongPress(project),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      child: CustomImageWidget(
                        imageUrl: project['thumbnail'] as String? ?? '',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project['title'] as String? ?? 'Untitled Project',
                            style: AppTheme.lightTheme.textTheme.titleSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              _buildStatusBadge(
                                  project['status'] as String? ?? 'pending'),
                              Spacer(),
                              CustomIconWidget(
                                iconName: 'location_on',
                                size: 16,
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor = AppTheme.getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
