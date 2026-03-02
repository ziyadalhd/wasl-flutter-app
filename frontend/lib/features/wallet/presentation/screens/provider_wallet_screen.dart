import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:wasl/features/wallet/presentation/widgets/transaction_item.dart';
import 'package:go_router/go_router.dart';

class ProviderWalletScreen extends StatefulWidget {
  const ProviderWalletScreen({super.key});

  @override
  State<ProviderWalletScreen> createState() => _ProviderWalletScreenState();
}

class _ProviderWalletScreenState extends State<ProviderWalletScreen> {
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
              balance: 750,
              showAddMoney: false,
              onWithdraw: () {
                context.push('/wallet/withdraw', extra: 750.0);
              },
            ),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'آخر العمليات',
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.push('/wallet/transactions');
                  },
                  child: Text(
                    'عرض المزيد',
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
