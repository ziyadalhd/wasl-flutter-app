import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/core/components/custom_text_field.dart';
import 'package:wasl/core/components/primary_button.dart';

class EnterAmountBottomSheet extends StatefulWidget {
  const EnterAmountBottomSheet({super.key});

  @override
  State<EnterAmountBottomSheet> createState() => _EnterAmountBottomSheetState();
}

class _EnterAmountBottomSheetState extends State<EnterAmountBottomSheet> {
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      // Dismiss the bottom sheet
      Navigator.pop(context);
      // Navigate to payment methods map to complete the flow
      context.push('/wallet/topup');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Add padding for keyboard to prevent it from covering the input field
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'إضافة مبلغ',
              style: GoogleFonts.tajawal(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'المبلغ المراد إضافته (ر.س)',
              hint: '0',
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Icons.account_balance_wallet_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال المبلغ';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'الرجاء إدخال مبلغ صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'المتابعة',
              onPressed: _onContinue,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
