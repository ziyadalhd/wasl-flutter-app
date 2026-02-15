import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:wasl/features/wallet/presentation/widgets/transaction_item.dart';
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
              onWithdraw: () {
                // Dummy action for now
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('سيتم تفعيل سحب المبلغ قريباً')),
                );
              },
            ),
            const SizedBox(height: 30),
            Text(
              'آخر العمليات',
              style: GoogleFonts.tajawal(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 16),
            // Replicating transactions from Provider Wallet as requested
            const TransactionItem(
              title: 'إيداع مبلغ خدمة ( سكن )',
              date: '19 Nov',
              isDeposit: true,
            ),
            const TransactionItem(
              title: 'سحب مبلغ خدمة ( نقل )',
              date: '6 Nov',
              isDeposit: false,
            ),
            const TransactionItem(
              title: 'إيداع مبلغ خدمة ( سكن )',
              date: '22 Oct',
              isDeposit: true,
            ),
            const TransactionItem(
              title: 'إيداع مبلغ خدمة ( سكن )',
              date: '17 Oct',
              isDeposit: true,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
