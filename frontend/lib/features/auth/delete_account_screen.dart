import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Added for GoRouter
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/core/components/primary_button.dart';
import 'package:wasl/core/components/custom_text_field.dart';
import 'package:wasl/features/auth/login_screen.dart';

class DeleteAccountScreen extends StatefulWidget {
  final String role; // 'student' or 'provider'

  const DeleteAccountScreen({super.key, required this.role});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _handleDeleteAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulation of API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Navigate to Login Screen and remove all previous routes
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7), // Cream background as per screenshot
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Logo Section
                 Center(
                   child: RichText(
                     text: const TextSpan(
                       children: [
                         TextSpan(
                           text: 'وصل',
                           style: TextStyle(
                             fontFamily: 'Tajawal',
                             fontSize: 80,
                             fontWeight: FontWeight.w900,
                             color: AppTheme.primaryColor,
                           ),
                         ),
                         TextSpan(
                           text: '.',
                           style: TextStyle(
                             fontFamily: 'Tajawal',
                             fontSize: 80,
                             fontWeight: FontWeight.w900,
                             color: AppTheme.secondaryColor,
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),

                const SizedBox(height: 60),

                // Password Header
                const Text(
                  'كلمة السر',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),

                const SizedBox(height: 30),
                
                // Password Field
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'كلمة المرور',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 14,
                        color: AppTheme.subtitleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Wrap in Theme to override border for "Clearer" look
                Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0), // More visible grey
                      ),
                    ),
                  ),
                  child: CustomTextField(
                    hint: '*****************',
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور';
                      }
                      if (value.length < 8) {
                        return 'كلمة المرور يجب أن تكون 8 خانات على الأقل';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // Warning Text
                const Text(
                  'نود إعلامك بأن حذف حسابك سيؤدي إلى فقدان جميع بياناتك بشكل نهائي، بما في ذلك سجلاتك السابقة وأي معلومات مرتبطة بخدماتك داخل منصة وصل.\nلن تتمكن من استعادة حسابك أو أي بيانات بعد إتمام عملية الحذف.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 16, // Increased from 15
                    color: AppTheme.textColor, // Changed to Black
                    fontWeight: FontWeight.bold, // Changed to Bold
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // Confirmation Question
                const Text(
                  'هل ترغب بالاستمرار في حذف الحساب؟',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 16,
                    color: AppTheme.textColor, // Changed to Black
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 32),

                // Delete Button
                SizedBox(
                  width: 200, // Fixed width as per screenshot look
                  child: PrimaryButton(
                     // Keep background as Primary (Teal) or White?
                     // "الكتابة بالبوتون حقت حذف الحساب مايله للاحمر" -> Text is red.
                     // Usually if text is red, background is light/white/transparent.
                     // The original PrimaryButton has primary background.
                     // If I set text to Red on Teal background, it looks bad.
                     // "Design clean...".
                     // Maybe the user wants the button itself to be Red? "Write on the button slanting red"?
                     // "الكتابة بالبوتون" = "The writing IN the button".
                     // If the background is Teal, Red text is vibrating.
                     // I will assume the button background should be light (or white) with Red Text, OR the Button Background is different.
                     // Wait, in the screenshot, the button was Teal.
                     // The USER REQUEST says: "First, I feel if you make the writing in the delete account button slanted to red it would be nice so it shows it's dangerous".
                     // This implies CHANGING the text color.
                     // If I change text to Red, I MUST change background to something lighter, e.g. Light Red or White with Red Border.
                     // I'll try a Light Red background with Red Text, often used for danger.
                     // OR just White background with Red Text.
                     // Let's try White background, Red Text.
                    text: 'حذف الحساب',
                    onPressed: _handleDeleteAccount,
                    isLoading: _isLoading,
                    backgroundColor: const Color(0xFFFFEBEE), // Very light red
                    textColor: AppTheme.errorColor,
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    if (widget.role == 'student') {
      return _buildStudentBottomBar(context);
    } else {
      return _buildProviderBottomBar(context);
    }
  }

  Widget _buildStudentBottomBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 2, // Home is active
        onTap: (index) {
          if (index == 2) {
            context.go('/student/home');
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey[400],
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'محفظتي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'محادثات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_filled),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            activeIcon: Icon(Icons.grid_view_rounded),
            label: 'الخدمات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'حجوزاتي',
          ),
        ],
      ),
    );
  }

  Widget _buildProviderBottomBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 2, // Home is active
        onTap: (index) {
          if (index == 2) {
            context.go('/service_provider/home');
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey[400],
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'محفظتي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'محادثات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_filled),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            activeIcon: Icon(Icons.grid_view_rounded),
            label: 'الخدمات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'لوحة المعلومات',
          ),
        ],
      ),
    );
  }
}
