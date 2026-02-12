import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';

class ServiceListingCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String? tagText; // Status (e.g., Active)
  final Color? tagColor;
  final VoidCallback? onTap;

  const ServiceListingCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.tagText,
    this.tagColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(left: 16, bottom: 8, top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1F24).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: AppTheme.primaryColor.withValues(alpha: 0.05),
          highlightColor: AppTheme.primaryColor.withValues(alpha: 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 140,
                      color: Colors.grey[100],
                      child: const Center(child: Icon(Icons.image_not_supported_rounded, color: Colors.grey)),
                    );
                  },
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.bold,
                              fontSize: 16, // Verified from student card
                              color: AppTheme.textColor,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 15,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (tagText != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            tagText!,
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12, // Verified
                              fontWeight: FontWeight.bold,
                              color: tagColor ?? Colors.green, // Default to green for "Active"
                            ),
                          ),
                        ],
                      ),
                    ],
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
