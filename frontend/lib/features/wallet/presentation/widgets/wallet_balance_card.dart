import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletBalanceCard extends StatelessWidget {
  final double balance;
  final VoidCallback? onAddMoney;
  final VoidCallback? onWithdraw;
  final bool showAddMoney;

  const WalletBalanceCard({
    super.key,
    required this.balance,
    this.onAddMoney,
    this.onWithdraw,
    this.showAddMoney = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF00796B), // Deep Teal from image
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'المبلغ المتاح',
            style: GoogleFonts.tajawal(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${balance.toInt()}',
                  style: GoogleFonts.tajawal(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Image.asset(
                          'assets/icons/Saudi_Riyal_Symbol.svg.png',
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showAddMoney || onWithdraw != null) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                if (showAddMoney && onAddMoney != null) ...[
                  // Right Button (in RTL): Add Amount
                  Expanded(
                    child: InkWell(
                      onTap: onAddMoney,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 48, // Fixed height for consistency
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'إضافة مبلغ',
                              style: GoogleFonts.tajawal(
                                fontSize: 14, // Adjusted for space
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                if (onWithdraw != null) ...[
                  // Left Button (in RTL): Withdraw Amount
                  Expanded(
                    child: InkWell(
                      onTap: onWithdraw,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 48, // Fixed height for consistency
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.remove, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'سحب مبلغ',
                              style: GoogleFonts.tajawal(
                                fontSize: 14, // Adjusted for space
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
