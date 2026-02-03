import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/components/custom_text_field.dart';
import 'package:wasl/core/components/primary_button.dart';
import 'package:wasl/core/theme/app_theme.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    bool formValid = _formKey.currentState?.validate() ?? false;

    if (!formValid) {
      return;
    }

    if (!_agreedToTerms) {
      // 2.a.1
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'لابد أن توافق على الشروط والأحكام للتسجيل',
            textAlign: TextAlign.right,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Success
    context.push('/role');
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'مطلوب';
    // 1.f: Complexity
    if (value.length < 8) {
      return '8 خانات';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'مطلوب';
    if (value != _passwordController.text) {
      // 1.e
      return 'غير متطابق';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                'وَصِل',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Header
                Text(
                  'إنشاء كلمة السر',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'قم بتعيين كلمة مرور قوية لحماية حسابك',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.subtitleColor,
                  ),
                ),

                const SizedBox(height: 60),

                // Password Fields
                CustomTextField(
                  label: 'كلمة المرور',
                  hint: '••••••••',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  controller: _passwordController,
                  validator: _validatePassword,
                  onChanged: (val) {
                    if (_confirmPasswordController.text.isNotEmpty) {
                      _formKey.currentState?.validate();
                    }
                  },
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'تأكيد كلمة المرور',
                  hint: '••••••••',
                  prefixIcon: Icons.verified_user_outlined,
                  obscureText: true,
                  controller: _confirmPasswordController,
                  validator: _validateConfirmPassword,
                ),

                const SizedBox(height: 40),

                // Terms and Conditions Checkbox
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        'أوافق على الشروط والأحكام',
                        textAlign: TextAlign.right,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                      ),
                    ),
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreedToTerms = value ?? false;
                        });
                      },
                      activeColor: AppTheme.primaryColor,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Register Button
                PrimaryButton(text: 'التالي', onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
