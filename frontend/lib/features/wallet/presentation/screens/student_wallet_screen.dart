import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:go_router/go_router.dart';

class StudentWalletScreen extends StatelessWidget {
  const StudentWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحفظة'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            WalletBalanceCard(
              balance: 330, // Example balance for student
              onAddMoney: () {
                context.push('/wallet/topup');
              },
            ),

            // No transaction list for Student as requested
            // But maybe we can show an empty state or just the card?
            // "Student also has a Wallet screen similar to Provider but without transactions."
            // So just the card is fine, and maybe some informative text?
            // Or maybe "Last Operations" but empty?
            // I'll stick to just the card for now to be safe, maybe add a spacer.
            const SizedBox(height: 40),
            Center(
              child: Text(
                'رصيدك الحالي في المحفظة',
                style: GoogleFonts.tajawal(
                  fontSize: 14,
                  color: AppTheme.subtitleColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
