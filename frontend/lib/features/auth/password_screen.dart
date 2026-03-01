import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/components/custom_text_field.dart';
import 'package:wasl/core/components/primary_button.dart';
import 'package:wasl/core/services/api_client.dart';
import 'package:wasl/core/services/auth_service.dart';
import 'package:wasl/core/theme/app_theme.dart';

class PasswordScreen extends StatefulWidget {
  final Map<String, dynamic>? signupData;

  const PasswordScreen({super.key, this.signupData});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    bool formValid = _formKey.currentState?.validate() ?? false;

    if (!formValid) {
      return;
    }

    if (!_agreedToTerms) {
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

    // Collect data from previous signup screen
    final data = widget.signupData;
    if (data == null) {
      // Fallback: no signup data was passed — navigate as before
      context.push('/welcome');
      return;
    }

    final fullName = data['fullName'] as String? ?? '';
    final email = data['email'] as String? ?? '';
    final phone = data['phone'] as String? ?? '';
    final city = data['city'] as String?;
    final password = _passwordController.text;

    setState(() => _isLoading = true);

    try {
      await AuthService.register(
        email: email,
        phone: phone.isNotEmpty ? phone : null,
        password: password,
        fullName: fullName,
        mode: 'STUDENT', // Default mode; role is chosen on role selection screen
        city: city,
      );

      if (!mounted) return;

      // Admin goes directly to admin dashboard, others go to role selection
      if (email.toLowerCase() == 'admin@wasl.com') {
        context.go('/admin');
      } else {
        context.push('/welcome');
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.userMessage, textAlign: TextAlign.right),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'حدث خطأ غير متوقع. الرجاء المحاولة لاحقاً.',
            textAlign: TextAlign.right,
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                PrimaryButton(
                  text: 'التالي',
                  onPressed: _submit,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
