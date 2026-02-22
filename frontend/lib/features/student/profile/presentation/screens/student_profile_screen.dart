import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/models/models.dart';
import 'package:wasl/core/services/api_client.dart';
import 'package:wasl/core/services/auth_service.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/student/profile/presentation/screens/edit_profile_screen.dart';
import 'package:wasl/features/student/profile/presentation/screens/manage_notifications_screen.dart';
import 'package:wasl/features/student/profile/presentation/screens/support_screen.dart';
import 'package:wasl/features/student/profile/presentation/screens/about_us_screen.dart';
import 'package:wasl/features/student/profile/presentation/screens/terms_conditions_screen.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  MeResponse? _meResponse;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final me = await AuthService.getMe();
      if (mounted) setState(() { _meResponse = me; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) context.go('/login');
  }

  Future<void> _switchToProvider() async {
    try {
      await AuthService.switchMode('PROVIDER');
      if (mounted) context.go('/service-provider-home');
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.userMessage, style: const TextStyle(fontFamily: 'Tajawal')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('حذف الحساب', style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
          content: const Text('هل أنت متأكد من حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.',
              style: TextStyle(fontFamily: 'Tajawal')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('حذف', style: TextStyle(fontFamily: 'Tajawal', color: Colors.red)),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true) {
      try {
        await AuthService.deleteAccount();
        await AuthService.logout();
        if (mounted) context.go('/login');
      } on ApiException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.userMessage, style: const TextStyle(fontFamily: 'Tajawal')),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _meResponse?.user;
    final displayName = user?.fullName ?? '...';
    final displayEmail = user?.email ?? '...';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0,
          title: const Text(
            'الملف الشخصي',
            style: TextStyle(
              color: AppTheme.textColor,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
            : RefreshIndicator(
                onRefresh: _loadProfile,
                color: AppTheme.primaryColor,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Profile Header Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                              child: Text(
                                displayName.isNotEmpty ? displayName[0] : '?',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                                color: AppTheme.textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              displayEmail,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Tajawal',
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'طالب',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Tajawal',
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Menu Items
                      _buildMenuItem(
                        icon: Icons.edit_outlined,
                        title: 'تعديل الملف الشخصي',
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                          );
                          if (result == true) _loadProfile();
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.notifications_outlined,
                        title: 'إدارة الإشعارات',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ManageNotificationsScreen()),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.support_agent_outlined,
                        title: 'الدعم الفني',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SupportScreen()),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.info_outline,
                        title: 'عن التطبيق',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.description_outlined,
                        title: 'الشروط والأحكام',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TermsConditionsScreen()),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Switch to Provider
                      _buildMenuItem(
                        icon: Icons.swap_horiz,
                        title: 'التبديل إلى مقدم خدمة',
                        iconColor: Colors.green,
                        onTap: _switchToProvider,
                      ),

                      const SizedBox(height: 10),

                      // Logout
                      _buildMenuItem(
                        icon: Icons.logout,
                        title: 'تسجيل الخروج',
                        iconColor: Colors.orange,
                        onTap: _logout,
                      ),

                      const SizedBox(height: 10),

                      // Delete Account
                      _buildMenuItem(
                        icon: Icons.delete_outline,
                        title: 'حذف الحساب',
                        iconColor: Colors.red,
                        textColor: Colors.red,
                        onTap: _deleteAccount,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
          onTap: (index) {
            if (index == 0) context.go('/student-wallet');
            if (index == 1) context.go('/chat');
            if (index == 2) context.go('/student-home');
            if (index == 3) context.go('/student-services');
            if (index == 4) context.go('/student-bookings');
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'المحفظة'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'المحادثات'),
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'الخدمات'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: 'الحجوزات'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = AppTheme.primaryColor,
    Color textColor = AppTheme.textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        trailing: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
