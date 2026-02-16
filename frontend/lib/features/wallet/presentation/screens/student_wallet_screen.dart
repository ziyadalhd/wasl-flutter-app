
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:wasl/features/wallet/presentation/widgets/transaction_item.dart';
import 'package:wasl/features/wallet/presentation/widgets/payment_card_widget.dart';
import 'package:wasl/features/wallet/presentation/screens/add_payment_card_screen.dart';
import 'package:go_router/go_router.dart';

class StudentWalletScreen extends StatefulWidget {
  const StudentWalletScreen({super.key});

  @override
  State<StudentWalletScreen> createState() => _StudentWalletScreenState();
}

class _StudentWalletScreenState extends State<StudentWalletScreen> {
  bool _isPaymentCardTop = false;
  Map<String, dynamic>? _savedCard; // Mock local state

  void _toggleCardOrder(bool isPaymentCard) {
    setState(() {
      _isPaymentCardTop = isPaymentCard;
    });
  }

  Future<void> _navigateToAddCard() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPaymentCardScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _savedCard = result;
        // After adding, show the payment card at the top to confirm
        _isPaymentCardTop = true; 
      });
    }
  }

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
            
            // Stacked Cards Area
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ));
              },
              child: Column(
                key: ValueKey<bool>(_isPaymentCardTop),
                children: _isPaymentCardTop
                    ? [
                         PaymentCardWidget(
                          isAdded: _savedCard != null,
                          onTap: () {
                             if (_savedCard == null) {
                               _navigateToAddCard();
                             }
                           },
                          cardNumber: _savedCard?['number'],
                          cardHolderName: _savedCard?['holderName'],
                          expiryDate: _savedCard?['expiry'],
                          isActive: true,
                         ),
                        const SizedBox(height: 16),
                         GestureDetector(
                           onTap: () => _toggleCardOrder(false),
                           child: AbsorbPointer(
                             absorbing: true,
                             child: WalletBalanceCard(
                                balance: 330, // Example balance for student
                                onAddMoney: () {
                                  context.push('/wallet/topup');
                                },
                                onWithdraw: () {
                                  context.push('/wallet/withdraw', extra: 330.0);
                                },
                             ),
                           ),
                         ),
                      ]
                    : [
                         WalletBalanceCard(
                            balance: 330,
                            onAddMoney: () {
                              context.push('/wallet/topup');
                            },
                            onWithdraw: () {
                              context.push('/wallet/withdraw', extra: 330.0);
                            },
                         ),
                        const SizedBox(height: 16),
                         PaymentCardWidget(
                          isAdded: _savedCard != null,
                          onTap: () {
                             _toggleCardOrder(true);
                          },
                          cardNumber: _savedCard?['number'],
                          cardHolderName: _savedCard?['holderName'],
                          expiryDate: _savedCard?['expiry'],
                          isActive: false,
                         ),
                      ],
              ),
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
