import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/theme/app_theme.dart';

class WithdrawScreen extends StatefulWidget {
  final double currentBalance;

  const WithdrawScreen({super.key, required this.currentBalance});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _ibanController = TextEditingController();
  
  bool _useFullBalance = false;

  @override
  void dispose() {
    _amountController.dispose();
    _ibanController.dispose();
    super.dispose();
  }

  void _toggleFullBalance(bool value) {
    setState(() {
      _useFullBalance = value;
      if (_useFullBalance) {
        _amountController.text = widget.currentBalance.toStringAsFixed(0);
      } else {
        _amountController.clear();
      }
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Navigate to success screen
      context.push('/wallet/withdraw/success');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'سحب مبلغ',
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المبلغ المراد سحبه ومعلومات الحساب',
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Balance Info & Full Balance Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الرصيد الحالي: ${widget.currentBalance.toStringAsFixed(0)} ر.س',
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'سحب كامل الرصيد',
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Switch(
                          value: _useFullBalance,
                          onChanged: _toggleFullBalance,
                          activeColor: AppTheme.primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
  
                // Amount Input
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  enabled: !_useFullBalance,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'المبلغ المراد سحبه',
                    labelStyle: GoogleFonts.tajawal(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixText: 'ر.س',
                    suffixStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال المبلغ';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null) {
                      return 'يرجى إدخال رقم صحيح';
                    }
                    if (amount <= 0) {
                      return 'المبلغ يجب أن يكون أكبر من صفر';
                    }
                    if (amount > widget.currentBalance) {
                      return 'المبلغ يتجاوز رصيد المحفظة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
  
                // IBAN Input
                TextFormField(
                  controller: _ibanController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: 'رقم الآيبان',
                    hintText: 'SA0000000000000000000000',
                    labelStyle: GoogleFonts.tajawal(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.account_balance),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم الآيبان';
                    }
                    if (!value.toUpperCase().startsWith('SA')) {
                      return 'رقم الآيبان يجب أن يبدأ بـ SA';
                    }
                    if (value.length < 24) { // Basic length check for SA IBAN (24 digits)
                       return 'رقم الآيبان غير مكتمل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
  
                // Informational Text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'سيتم استلام طلب سحب المبلغ من محفظتك وتحويل المبلغ إلى رقم الحساب البنكي المسجل خلال يومين عمل كحد أقصى.',
                              style: GoogleFonts.tajawal(
                                fontSize: 13,
                                height: 1.5,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'في حال وجود أي مشكلة في بيانات الحساب أو تأخر غير متوقع سيتم التواصل معك مباشرة.',
                        style: GoogleFonts.tajawal(
                          fontSize: 13,
                          height: 1.5,
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
  
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'سحب المبلغ',
                      style: GoogleFonts.tajawal(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
