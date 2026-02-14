import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListItem extends StatelessWidget {
  final String name;
  final String role;
  final String message;
  final String imageUrl;
  final bool hasWarning;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.name,
    required this.role,
    required this.message,
    required this.imageUrl,
    this.hasWarning = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2FA898), // Teal color
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Warning Icon (Far Left in RTL means End? No, Start)
            // Layout is LTR in code, but Directionality is RTL.
            // In RTL: Start is Right, End is Left.
            // Image shows:
            // [Warning] ... [Text] ... [Avatar]
            // Left .................... Right

            // So in RTL:
            // [Avatar] [Text] [Spacer] [Warning]
            // Start .................... End

            // Let's build standard Row order for RTL:

            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(imageUrl),
              backgroundColor: Colors.grey[200],
              child: imageUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),

            const SizedBox(width: 12),

            // Name and Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.tajawal(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Verify Icon if needed?
                      const Icon(
                        Icons.check_circle,
                        color: Colors.black,
                        size: 14,
                      ),
                      // The image shows a small checkmark next to name? Or is it part of name?
                      // "Muaath Buqus <Check>"
                      // It's a black checkmark.
                    ],
                  ),
                  Text(
                    role,
                    style: GoogleFonts.tajawal(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: GoogleFonts.tajawal(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Warning Icon (Left side)
            if (hasWarning)
              Icon(
                Icons.warning_amber_rounded, // Triangle with !
                color: Colors.black.withValues(
                  alpha: 0.5,
                ), // Looks like dark grey/black outline
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
