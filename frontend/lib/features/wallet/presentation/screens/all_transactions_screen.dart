import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/wallet/presentation/widgets/transaction_item.dart';

class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate some mock transactions to show a full list
    final List<Map<String, dynamic>> mockTransactions = [
      {'title': 'إيداع مبلغ خدمة ( سكن )', 'date': '19 Nov', 'isDeposit': true},
      {'title': 'سحب مبلغ خدمة ( نقل )', 'date': '6 Nov', 'isDeposit': false},
      {'title': 'إيداع مبلغ خدمة ( سكن )', 'date': '22 Oct', 'isDeposit': true},
      {'title': 'إيداع مبلغ خدمة ( سكن )', 'date': '17 Oct', 'isDeposit': true},
      {'title': 'سحب إلى الحساب البنكي', 'date': '10 Oct', 'isDeposit': false},
      {'title': 'إيداع مبلغ خدمة ( نقل )', 'date': '01 Oct', 'isDeposit': true},
      {'title': 'إيداع مبلغ خدمة ( سكن )', 'date': '28 Sep', 'isDeposit': true},
      {'title': 'إيداع مبلغ خدمة ( سكن )', 'date': '15 Sep', 'isDeposit': true},
      {'title': 'سحب إلى الحساب البنكي', 'date': '05 Sep', 'isDeposit': false},
      {'title': 'إيداع مبلغ خدمة ( نقل )', 'date': '20 Aug', 'isDeposit': true},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'جميع العمليات',
          style: GoogleFonts.tajawal(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textColor),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: mockTransactions.length,
        itemBuilder: (context, index) {
          final tx = mockTransactions[index];
          return TransactionItem(
            title: tx['title'],
            date: tx['date'],
            isDeposit: tx['isDeposit'],
          );
        },
      ),
    );
  }
}
