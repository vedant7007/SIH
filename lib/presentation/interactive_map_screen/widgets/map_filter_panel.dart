import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapFilterPanel extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onClose;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const MapFilterPanel({
    Key? key,
    required this.isVisible,
    required this.onClose,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<MapFilterPanel> createState() => _MapFilterPanelState();
}

class _MapFilterPanelState extends State<MapFilterPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  String selectedStatus = 'All';
  DateTimeRange? selectedDateRange;
  bool creditAvailable = false;
  bool geofencingEnabled = false;

  final List<String> statusOptions = ['All', 'Approved', 'Pending', 'Rejected'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(MapFilterPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _animationController.forward();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final filters = {
      'status': selectedStatus,
      'dateRange': selectedDateRange,
      'creditAvailable': creditAvailable,
      'geofencingEnabled': geofencingEnabled,
    };
    widget.onFiltersChanged(filters);
    widget.onClose();
  }

  void _clearFilters() {
    setState(() {
      selectedStatus = 'All';
      selectedDateRange = null;
      creditAvailable = false;
      geofencingEnabled = false;
    });
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.primaryLight,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: 80.w,
        height: 100.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(2, 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.dividerLight,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Filters',
                      style: AppTheme.lightTheme.textTheme.titleLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: widget.onClose,
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.textPrimaryLight,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Filter Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Status Filter
                      Text(
                        'Project Status',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 2.h),
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children: statusOptions.map((status) {
                          final isSelected = selectedStatus == status;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedStatus = status;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryLight
                                    : AppTheme.lightTheme.colorScheme.surface,
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primaryLight
                                      : AppTheme.dividerLight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: isSelected
                                      ? AppTheme.onPrimaryLight
                                      : AppTheme.textPrimaryLight,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 3.h),

                      // Date Range Filter
                      Text(
                        'Date Range',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 2.h),
                      GestureDetector(
                        onTap: _selectDateRange,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.dividerLight),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'calendar_today',
                                color: AppTheme.textSecondaryLight,
                                size: 20,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  selectedDateRange != null
                                      ? '${selectedDateRange!.start.day}/${selectedDateRange!.start.month}/${selectedDateRange!.start.year} - ${selectedDateRange!.end.day}/${selectedDateRange!.end.month}/${selectedDateRange!.end.year}'
                                      : 'Select date range',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: selectedDateRange != null
                                        ? AppTheme.textPrimaryLight
                                        : AppTheme.textSecondaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Credit Availability Filter
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Credits Available',
                              style: AppTheme.lightTheme.textTheme.titleMedium,
                            ),
                          ),
                          Switch(
                            value: creditAvailable,
                            onChanged: (value) {
                              setState(() {
                                creditAvailable = value;
                              });
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),

                      // Geofencing Filter
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Show Geofencing',
                              style: AppTheme.lightTheme.textTheme.titleMedium,
                            ),
                          ),
                          Switch(
                            value: geofencingEnabled,
                            onChanged: (value) {
                              setState(() {
                                geofencingEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Action Buttons
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.dividerLight,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _clearFilters,
                        child: Text('Clear All'),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _applyFilters,
                        child: Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
