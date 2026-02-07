import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';

class ListingCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String? tagText;
  final VoidCallback? onTap;

  const ListingCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.tagText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220, // Slightly wider for better breathing room
      margin: const EdgeInsets.only(left: 16, bottom: 8, top: 4), // Added vertical margin for shadow clipping
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Increased radius
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1F24).withValues(alpha: 0.08), // Softer, more premium shadow
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
                  height: 140, // Taller image
                  width: double.infinity,
                  fit: BoxFit.cover,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) return child;
                    return AnimatedOpacity(
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      child: child,
                    );
                  },
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
                padding: const EdgeInsets.all(16.0), // Increased padding
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
                              fontSize: 16,
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
                        color: AppTheme.primaryColor, // Highlight price/subtitle
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (tagText != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tagText!,
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
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
