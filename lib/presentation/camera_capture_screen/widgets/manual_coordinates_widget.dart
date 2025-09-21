import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ManualCoordinatesWidget extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final Function(double?, double?) onCoordinatesChanged;
  final VoidCallback onClose;

  const ManualCoordinatesWidget({
    Key? key,
    this.initialLatitude,
    this.initialLongitude,
    required this.onCoordinatesChanged,
    required this.onClose,
  }) : super(key: key);

  @override
  State<ManualCoordinatesWidget> createState() =>
      _ManualCoordinatesWidgetState();
}

class _ManualCoordinatesWidgetState extends State<ManualCoordinatesWidget> {
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _latitudeController = TextEditingController(
      text: widget.initialLatitude?.toStringAsFixed(6) ?? '',
    );
    _longitudeController = TextEditingController(
      text: widget.initialLongitude?.toStringAsFixed(6) ?? '',
    );
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Manual Coordinates Entry',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onClose,
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Form
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Latitude field
                  TextFormField(
                    controller: _latitudeController,
                    decoration: InputDecoration(
                      labelText: 'Latitude',
                      hintText: 'e.g., 17.385044',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'my_location',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^-?\d*\.?\d*'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter latitude';
                      }
                      final lat = double.tryParse(value);
                      if (lat == null) {
                        return 'Invalid latitude format';
                      }
                      if (lat < -90 || lat > 90) {
                        return 'Latitude must be between -90 and 90';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 2.h),

                  // Longitude field
                  TextFormField(
                    controller: _longitudeController,
                    decoration: InputDecoration(
                      labelText: 'Longitude',
                      hintText: 'e.g., 78.486671',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'place',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^-?\d*\.?\d*'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter longitude';
                      }
                      final lng = double.tryParse(value);
                      if (lng == null) {
                        return 'Invalid longitude format';
                      }
                      if (lng < -180 || lng > 180) {
                        return 'Longitude must be between -180 and 180';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onClose,
                          child: Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveCoordinates,
                          child: Text('Save'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveCoordinates() {
    if (_formKey.currentState?.validate() ?? false) {
      final latitude = double.tryParse(_latitudeController.text);
      final longitude = double.tryParse(_longitudeController.text);

      widget.onCoordinatesChanged(latitude, longitude);
      widget.onClose();
    }
  }
}
