import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AIVerificationWidget extends StatelessWidget {
  final double overallConfidence;
  final List<Map<String, dynamic>> verificationResults;
  final List<String> flaggedConcerns;

  const AIVerificationWidget({
    Key? key,
    required this.overallConfidence,
    required this.verificationResults,
    required this.flaggedConcerns,
  }) : super(key: key);

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return AppTheme.successLight;
    if (confidence >= 0.6) return AppTheme.accentLight;
    return AppTheme.errorLight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'psychology',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Verification Analysis',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Automated project validation results',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Overall Confidence Score
          _buildOverallConfidenceSection(),
          SizedBox(height: 3.h),

          // Detailed Verification Results
          _buildDetailedResultsSection(),

          // Flagged Concerns
          if (flaggedConcerns.isNotEmpty) ...[
            SizedBox(height: 3.h),
            _buildFlaggedConcernsSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildOverallConfidenceSection() {
    final confidenceColor = _getConfidenceColor(overallConfidence);
    final confidencePercentage = (overallConfidence * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall Confidence Score',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: overallConfidence,
                  child: Container(
                    decoration: BoxDecoration(
                      color: confidenceColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: confidenceColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$confidencePercentage%',
                style: AppTheme.getDataTextStyle(
                  isLight: true,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ).copyWith(color: confidenceColor),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailedResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Analysis',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        ...verificationResults
            .map((result) => _buildResultItem(result))
            .toList(),
      ],
    );
  }

  Widget _buildResultItem(Map<String, dynamic> result) {
    final String category = result['category'] as String;
    final double score = (result['score'] as num).toDouble();
    final String status = result['status'] as String;
    final Color statusColor = _getConfidenceColor(score);

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  status,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${(score * 100).round()}%',
              style: AppTheme.getDataTextStyle(
                isLight: true,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ).copyWith(color: statusColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlaggedConcernsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              size: 20,
              color: AppTheme.warningLight,
            ),
            SizedBox(width: 2.w),
            Text(
              'Flagged Concerns',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.warningLight,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ...flaggedConcerns
            .map((concern) => Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.warningLight.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.warningLight.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'error_outline',
                        size: 16,
                        color: AppTheme.warningLight,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          concern,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }
}
