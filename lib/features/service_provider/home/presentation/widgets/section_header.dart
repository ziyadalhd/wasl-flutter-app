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
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
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
           // Optional: Hidden "View More" if not needed, or keep it consistent
           // For now keeping it consistent with student app layout
          //  if (false) ...[
          //    TextButton(...)
          //  ]
        ],
      ),
    );
  }
}
