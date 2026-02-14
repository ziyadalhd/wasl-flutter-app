import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final bool isDeposit;

  const TransactionItem({
    super.key,
    required this.title,
    required this.date,
    required this.isDeposit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2FA898), // Lighter teal as shown in image list
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon is on the RIGHT in RTL? No, Flutter handles RTL automatically for Row.
          // If we want the icon to be at the START (Right in RTL), we put it first in the Row.
          Icon(
            isDeposit ? Icons.download_rounded : Icons.upload_rounded,
            color: isDeposit
                ? const Color(0xFF4CAF50)
                : const Color(0xFFE57373), // A bit brighter green/red
            size: 28,
          ),

          Expanded(
            child: Column(
              children: [
                Text(
                  title,
                  style: GoogleFonts.tajawal(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: GoogleFonts.tajawal(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Dummy spacer to balance icon
          const SizedBox(width: 28),
        ],
      ),
    );
  }
}
