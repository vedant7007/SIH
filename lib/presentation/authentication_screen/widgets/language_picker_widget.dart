import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LanguagePickerWidget extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const LanguagePickerWidget({
    Key? key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Updated to South Indian languages as requested
    final languages = [
      {'code': 'en', 'name': 'English', 'flag': '🇮🇳'},
      {'code': 'te', 'name': 'తెలుగు', 'flag': '🇮🇳'},
      {'code': 'ta', 'name': 'தமிழ்', 'flag': '🇮🇳'},
      {'code': 'kn', 'name': 'ಕನ್ನಡ', 'flag': '🇮🇳'},
      {'code': 'ml', 'name': 'മലയാളം', 'flag': '🇮🇳'},
    ];

    final selectedLang = languages.firstWhere(
      (lang) => lang['code'] == selectedLanguage,
      orElse: () => languages.first,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: DropdownButton<String>(
        value: selectedLanguage,
        underline: SizedBox.shrink(),
        icon: CustomIconWidget(
          iconName: 'keyboard_arrow_down',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 4.w,
        ),
        items:
            languages.map((language) {
              return DropdownMenuItem<String>(
                value: language['code'] as String,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      language['flag'] as String,
                      style: TextStyle(fontSize: 4.w),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      language['name'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onLanguageChanged(newValue);
          }
        },
      ),
    );
  }
}
