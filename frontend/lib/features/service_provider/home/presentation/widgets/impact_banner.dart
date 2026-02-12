import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';

class ImpactBanner extends StatelessWidget {
  const ImpactBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1), // Light version of Primary color
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Stack(
        children: [
           // Optional: Background decoration pattern from student home promo can be added here
           Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تأثيرك معنا!',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'مساهمتك تحدث فرقاً في حياة الطلاب وتدعم التنمية المجتمعية من خلال العمل التطوعي.',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 15,
                    height: 1.5,
                    color: AppTheme.textColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
