import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wasl/core/theme/app_theme.dart';

class PaymentCardWidget extends StatelessWidget {
  final bool isAdded;
  final VoidCallback onTap;
  final String? cardNumber;
  final String? cardHolderName;
  final String? expiryDate;
  final bool isActive;

  const PaymentCardWidget({
    super.key,
    required this.isAdded,
    required this.onTap,
    this.cardNumber,
    this.cardHolderName,
    this.expiryDate,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2D3E50) :Colors.white, 
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isActive ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.05),
              blurRadius: isActive ? 15 : 10,
              offset: isActive ? const Offset(0, 8) : const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isActive ? Colors.transparent : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: isAdded ? _buildSavedCardContent() : _buildAddCardContent(),
      ),
    );
  }

  Widget _buildAddCardContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.credit_card,
          size: 40,
          color: isActive ? Colors.white : const Color(0xFF00796B),
        ),
        const SizedBox(height: 12),
        Text(
          'إضافة بطاقة',
          style: GoogleFonts.tajawal(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'لإضافة وسيلة دفع جديدة',
          style: GoogleFonts.tajawal(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white70 : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSavedCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.credit_card, // Placeholder for Brand Icon
              color: isActive ? Colors.white : const Color(0xFF00796B),
              size: 32,
            ),
             Icon(
              Icons.nfc,
              color: isActive ? Colors.white54 : Colors.grey,
              size: 24,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          cardNumber ?? '**** **** **** ****',
          style: GoogleFonts.tajawal(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: isActive ? Colors.white : AppTheme.textColor,
          ),
          textDirection: TextDirection.ltr,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اسم حامل البطاقة',
                  style: GoogleFonts.tajawal(
                    fontSize: 12,
                    color: isActive ? Colors.white60 : Colors.grey,
                  ),
                ),
                Text(
                  cardHolderName ?? 'USER NAME',
                  style: GoogleFonts.tajawal(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.white : AppTheme.textColor,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'تاريخ الانتهاء',
                  style: GoogleFonts.tajawal(
                    fontSize: 12,
                    color: isActive ? Colors.white60 : Colors.grey,
                  ),
                ),
                Text(
                  expiryDate ?? 'MM/YY',
                  style: GoogleFonts.tajawal(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.white : AppTheme.textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
