import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewMore;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onViewMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0), // Reduced vertical padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
              fontFamily: 'Tajawal',
              letterSpacing: -0.5,
            ),
          ),
           TextButton(
            onPressed: onViewMore,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'عرض المزيد',
                  style: TextStyle(
                    fontSize: 12, // Slightly smaller for elegance
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_back_ios_new_rounded, // Arrow pointing left for RTL
                  size: 10,
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
