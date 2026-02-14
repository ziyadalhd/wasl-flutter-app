import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wasl/core/theme/app_theme.dart';

class WalletTopUpScreen extends StatefulWidget {
  const WalletTopUpScreen({super.key});

  @override
  State<WalletTopUpScreen> createState() => _WalletTopUpScreenState();
}

class _WalletTopUpScreenState extends State<WalletTopUpScreen> {
  String _selectedMethod = 'card'; // Default to card

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدفع'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'طرق الدفع',
              style: GoogleFonts.tajawal(
                fontSize: 18,
                color: AppTheme.subtitleColor,
              ),
            ),
            const SizedBox(height: 24),

            // Card Payment Option
            _buildPaymentOption(
              id: 'card',
              icon: Icons.credit_card_rounded,
              label: 'بطاقة ائتمانية',
              isSelected: _selectedMethod == 'card',
              onTap: () => setState(() => _selectedMethod = 'card'),
            ),

            const SizedBox(height: 16),

            // Apple Pay Option
            _buildPaymentOption(
              id: 'apple_pay',
              icon: Icons.apple,
              label: 'Apple Pay',
              isSelected: _selectedMethod == 'apple_pay',
              onTap: () => setState(() => _selectedMethod = 'apple_pay'),
              isApplePay: true,
            ),

            const Spacer(),

            // Confirm Button (Optional, not in screenshot but needed for interaction)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Todo: Process Payment
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'تأكيد الدفع',
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool isApplePay = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF2FA898), // Teal color from design
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppTheme.primaryColor, width: 2)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side (Icon)
            Icon(icon, color: Colors.white, size: 28),

            // Right side (Label and Check if selected?)
            // Based on image:
            // "Credit Card" text is left-aligned (English) or right-aligned (Arabic)?
            // It says "بطاقة ائتمانية" on the RIGHT.
            // And "Apple Pay" on the right.
            // Icons are on the LEFT.
            // Wait, standard RTL: Icon on Right, Text on Left.
            // But the image screenshot shows:
            // "Credit Card Icon" on LEFT. "Text" on RIGHT.
            // This is LTR layout visually? Or standard customization?
            // "Wallet top-up Page" Image:
            // Back arrow on Left. Title "الدفع" Centered/Right.
            // "Payment Methods" Centered(?).
            // Button 1: Icon (Card) on Left. Text (Arabic) on Right. Checkmark? No checkmark visible.
            // Button 2: Icon (Apple) on Left. Text (Apple Pay) on Right.

            // Let's stick to standard Row: [Icon, Spacer, Text].
            // If direction is RTL, Row starts from Right. So [Icon, Spacer, Text] means Icon is on Right.
            // But we want Icon on Left and Text on Right (as per screenshot).
            // So in RTL, we should put Text first, then Spacer, then Icon.
            Text(
              label,
              style: GoogleFonts.tajawal(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // In RTL, this text will be on the Right.

            // Wait, if I want Icon on Left and Text on Right in RTL:
            // I need to use Directionality or just place them in order [Text, Spacer, Icon] ?
            // BuildContext directionality is likely RTL.
            // Row in RTL: [Start (Right), ..., End (Left)].
            // If I put [Text, Spacer, Icon]:
            // Text is at Start (Right). Spacer. Icon is at End (Left).
            // Matches screenshot: Text on Right, Icon on Left.

            // BUT, what if the user language is English?
            // Screenshot has Arabic text.
            // I'll stick to [Text, Spacer, Icon].

            // The screenshot actually shows:
            // Item 1: [Icon (Card)] ---------- [Text (Credit Card)] (Selected state maybe?)
            // Item 2: [Icon (Apple)] ---------- [Text (Apple Pay)]

            // Let's re-examine image 1.
            // "Wallet top-up Page"
            // Top-Left: Back Arrow.
            // Top-Right: "الدفع" (Title).
            // Middle text: "طرق الدفع"
            // List Item 1:
            // Left: Card Icon inside a box? No just icon.
            // Right: Text "بطاقة ائتمانية".
            // Background: Teal.

            // OK so visually: Left = Icon. Right = Text.
            // In RTL (Right to Left): End = Left. Start = Right.
            // So Icon is at End. Text is at Start.
          ],
        ),
      ),
    );
  }
}
