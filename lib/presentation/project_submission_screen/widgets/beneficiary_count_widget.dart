import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BeneficiaryCountWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String? errorText;

  const BeneficiaryCountWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Beneficiary Count',
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
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          'Number of people who will benefit from this project',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            // Decrease Button
            GestureDetector(
              onTap: () => _decreaseCount(),
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'remove',
                  color: _getCurrentCount() > 0
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.5),
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(width: 4.w),

            // Count Input Field
            Expanded(
              child: TextFormField(
                controller: controller,
                onChanged: onChanged,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                decoration: InputDecoration(
                  hintText: '0',
                  errorText: errorText,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'people',
                      color: errorText != null
                          ? AppTheme.lightTheme.colorScheme.error
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                  suffixText: 'people',
                  suffixStyle:
                      AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                style: AppTheme.getDataTextStyle(
                  isLight: true,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(width: 4.w),

            // Increase Button
            GestureDetector(
              onTap: () => _increaseCount(),
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Quick Selection Buttons
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            _buildQuickSelectButton('10'),
            _buildQuickSelectButton('50'),
            _buildQuickSelectButton('100'),
            _buildQuickSelectButton('500'),
            _buildQuickSelectButton('1000'),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickSelectButton(String value) {
    final isSelected = controller.text == value;

    return GestureDetector(
      onTap: () {
        controller.text = value;
        onChanged(value);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          value,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  int _getCurrentCount() {
    return int.tryParse(controller.text) ?? 0;
  }

  void _decreaseCount() {
    final currentCount = _getCurrentCount();
    if (currentCount > 0) {
      final newCount = currentCount - 1;
      controller.text = newCount.toString();
      onChanged(newCount.toString());
    }
  }

  void _increaseCount() {
    final currentCount = _getCurrentCount();
    final newCount = currentCount + 1;
    controller.text = newCount.toString();
    onChanged(newCount.toString());
  }
}
