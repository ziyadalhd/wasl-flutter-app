import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/student/profile/presentation/screens/support_chat_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppTheme.textColor,
                size: 18,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          title: const Text(
            'الدعم والمساعدة',
            style: TextStyle(
              color: AppTheme.textColor,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
            left: 20,
          ), // Adjust for visual balance
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SupportChatScreen(),
                ),
              );
            },
            elevation: 4,
            shape: const CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: AppTheme.textColor,
                size: 28,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.endFloat, // In RTL end is Left
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Spacer(flex: 1),
                // Big Logo
                Text(
                  'وَصِل.',
                  style: GoogleFonts.tajawal(
                    fontSize: 100,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF268E82), // Teal matching screenshot
                    height: 1.0,
                  ),
                ),

                const Spacer(flex: 1),

                // Buttons
                _buildSupportButton(
                  title: 'الشروط والأحكام',
                  icon: Icons.assignment_outlined,
                  onTap: () {
                    context.push('/student/profile/support/terms');
                  },
                ),
                const SizedBox(height: 16),
                _buildSupportButton(
                  title: 'من نحن',
                  icon: Icons.info_outline_rounded,
                  onTap: () {
                    context.push('/student/profile/support/about');
                  },
                ),

                const Spacer(flex: 2),

                // Bottom visuals (part of scaffold bottom nav)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupportButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF268E82),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Icon (in RTL this is end) -> Screenshot shows icon at the END (Left side).
            // Text is on the Right.
            // Screenshot: [Text ...... Icon]
            const SizedBox(width: 24), // Balance

            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),

            const Spacer(),

            Icon(icon, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
