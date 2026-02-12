import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/components/custom_text_field.dart';
import 'package:wasl/core/components/primary_button.dart';
import 'package:wasl/core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    bool valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'الرجاء تعبئة جميع الحقول المطلوبة.',
            textAlign: TextAlign.right,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final email = _emailController.text.trim();
    // 2.b.1 Inactive
    if (email == 'inactive@wasl.com') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'الحساب غير مفعل. الرجاء التواصل مع الدعم الفني.',
            textAlign: TextAlign.right,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // 2.a.1 Incorrect
    if (email == 'wrong@wasl.com') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
            textAlign: TextAlign.right,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Success (Mock)
    context.go('/student/home');
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'مطلوب';
    final emailExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailExp.hasMatch(value)) {
      return 'بريد غير صحيح';
    }
    return null;
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) return 'مطلوب';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Animated Logo / Header
                Hero(
                  tag: 'app_logo',
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'وَصِل',
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 64,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'تسجيل الدخول',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Form
                CustomTextField(
                  label: 'البريد الالكتروني',
                  hint: 'name@example.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'كلمة المرور',
                  hint: '••••••••',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  controller: _passwordController,
                  validator: _validateRequired,
                ),

                // Forgot Password removed as per request
                const SizedBox(height: 32),

                // Login Button
                PrimaryButton(text: 'تسجيل دخول', onPressed: _submit),

                const SizedBox(height: 24),

                // Create Account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => context.push('/signup'),
                      child: const Text('إنشاء حساب'),
                    ),
                    Text(
                      'ليس لديك حساب؟',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.subtitleColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Footer slogan
                Opacity(
                  opacity: 0.7,
                  child: Text(
                    'حلقة الوصل لرحلتك الجامعية\nمع وَصِل.. دربك خضر',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(height: 1.6),
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
