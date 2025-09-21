import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapOverlayControls extends StatefulWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;
  final VoidCallback onLocationTap;
  final VoidCallback onLayerToggle;
  final String currentLayer;
  final bool isLocationLoading;

  const MapOverlayControls({
    Key? key,
    required this.onSearchTap,
    required this.onFilterTap,
    required this.onLocationTap,
    required this.onLayerToggle,
    required this.currentLayer,
    this.isLocationLoading = false,
  }) : super(key: key);

  @override
  State<MapOverlayControls> createState() => _MapOverlayControlsState();
}

class _MapOverlayControlsState extends State<MapOverlayControls> {
  bool _isLayerMenuOpen = false;
  final List<String> _layerOptions = ['Standard', 'Satellite', 'Terrain'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Top Controls Row
            Row(
              children: [
                // Search Bar
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onSearchTap,
                    child: Container(
                      height: 6.h,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.shadowLight,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'search',
                            color: AppTheme.textSecondaryLight,
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'Search projects or locations...',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Filter Button
                _buildControlButton(
                  icon: 'filter_list',
                  onTap: widget.onFilterTap,
                ),
              ],
            ),

            const Spacer(),

            // Bottom Right Controls
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Layer Toggle Button with Menu
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_isLayerMenuOpen) ...[
                      Container(
                        margin: EdgeInsets.only(bottom: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.shadowLight,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: _layerOptions.map((layer) {
                            final isSelected = widget.currentLayer == layer;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isLayerMenuOpen = false;
                                });
                                widget.onLayerToggle();
                              },
                              child: Container(
                                width: 35.w,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 1.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.primaryLight
                                          .withValues(alpha: 0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: _getLayerIcon(layer),
                                      color: isSelected
                                          ? AppTheme.primaryLight
                                          : AppTheme.textPrimaryLight,
                                      size: 18,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      layer,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: isSelected
                                            ? AppTheme.primaryLight
                                            : AppTheme.textPrimaryLight,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],

                    // Layer Toggle Button
                    _buildControlButton(
                      icon: 'layers',
                      onTap: () {
                        setState(() {
                          _isLayerMenuOpen = !_isLayerMenuOpen;
                        });
                      },
                      isActive: _isLayerMenuOpen,
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // My Location Button
                _buildControlButton(
                  icon: 'my_location',
                  onTap: widget.onLocationTap,
                  isLoading: widget.isLocationLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required String icon,
    required VoidCallback onTap,
    bool isActive = false,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 12.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primaryLight
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isActive
                          ? AppTheme.onPrimaryLight
                          : AppTheme.primaryLight,
                    ),
                  ),
                ),
              )
            : Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: isActive
                      ? AppTheme.onPrimaryLight
                      : AppTheme.textPrimaryLight,
                  size: 24,
                ),
              ),
      ),
    );
  }

  String _getLayerIcon(String layer) {
    switch (layer) {
      case 'Satellite':
        return 'satellite';
      case 'Terrain':
        return 'terrain';
      default:
        return 'map';
    }
  }
}
