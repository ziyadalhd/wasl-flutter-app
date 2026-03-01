import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/components/custom_text_field.dart';
import 'package:wasl/core/components/primary_button.dart';
import 'package:wasl/core/services/api_client.dart';
import 'package:wasl/core/services/auth_service.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
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
    final password = _passwordController.text;

    setState(() => _isLoading = true);

    try {
      await AuthService.login(email, password);

      if (!mounted) return;

      // Fetch user profile to determine the active mode
      final me = await AuthService.getMe();

      if (!mounted) return;

      // Check if user is admin → go directly to admin dashboard
      final isAdmin = me.user.roles.contains('ADMIN') ||
          me.user.email.toLowerCase() == 'admin@wasl.com';
      if (isAdmin) {
        context.go('/admin');
      } else if (me.mode == 'STUDENT') {
        context.go('/student/home');
      } else {
        context.go('/service_provider/home');
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
                PrimaryButton(
                  text: 'تسجيل دخول',
                  onPressed: _submit,
                  isLoading: _isLoading,
                ),

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
