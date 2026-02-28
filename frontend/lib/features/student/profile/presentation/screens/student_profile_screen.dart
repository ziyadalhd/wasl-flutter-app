import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/models/models.dart';
import 'package:wasl/core/services/api_client.dart';
import 'package:wasl/core/services/auth_service.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/student/profile/presentation/screens/edit_profile_screen.dart';
import 'package:wasl/features/student/profile/presentation/screens/manage_notifications_screen.dart';
import 'package:wasl/features/student/profile/presentation/screens/support_screen.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  MeResponse? _meResponse;
  bool _isLoading = true;
  bool isVerified = false;

  final List<String> _universities = [
    'جامعة أم القرى',
    'جامعة الملك عبدالعزيز',
    'جامعة الملك سعود',
    'جامعة الملك فهد للبترول والمعادن',
    'جامعة الملك فيصل',
    'جامعة الملك خالد',
    'الجامعة الإسلامية بالمدينة المنورة',
    'جامعة الإمام محمد بن سعود الإسلامية',
    'جامعة طيبة',
    'جامعة القصيم',
    'جامعة حائل',
    'جامعة جازان',
    'جامعة الجوف',
    'جامعة تبوك',
    'جامعة نجران',
    'جامعة الباحة',
    'جامعة الحدود الشمالية',
    'جامعة الأمير سطام بن عبدالعزيز',
    'جامعة شقراء',
    'جامعة المجمعة',
    'جامعة الطائف',
    'جامعة بيشة',
    'جامعة جدة',
    'جامعة حفر الباطن',
    'جامعة الأميرة نورة بنت عبدالرحمن',
    'جامعة الملك سعود بن عبدالعزيز للعلوم الصحية',
    'جامعة الملك عبدالله للعلوم والتقنية',
    'الجامعة السعودية الإلكترونية',
    'جامعة الأمير سلطان',
    'جامعة دار الحكمة',
  ];
  List<String> _colleges = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final me = await AuthService.getMe();
      List<String> loadedColleges = [];
      try {
        final collList = await AuthService.getColleges();
        loadedColleges = collList.map((c) => c['name'] as String).toList();
      } catch (_) {}
      
      if (mounted) {
        setState(() { 
        _meResponse = me; 
        _colleges = loadedColleges;
        _isLoading = false; 
      });
      }
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
      await AuthService.switchMode();
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
    final passwordController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تأكيد حذف الحساب', style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('يرجى إدخال كلمة المرور الخاصة بك لتأكيد عملية الحذف. هذا الإجراء لا يمكن التراجع عنه',
                  style: TextStyle(fontFamily: 'Tajawal')),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'كلمة المرور',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('تأكيد الحذف', style: TextStyle(fontFamily: 'Tajawal', color: Colors.red)),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true) {
      if (passwordController.text.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('يرجى إدخال كلمة المرور', style: TextStyle(fontFamily: 'Tajawal')),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
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

  void _showVerificationBottomSheet() {
    String? selectedUniversity;
    String? selectedCollege;
    final formKey = GlobalKey<FormState>();
    final studentIdController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'توثيق الحساب',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // University
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'الجامعة',
                      labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: _universities.map((u) => DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(fontFamily: 'Tajawal')))).toList(),
                    onChanged: (val) => selectedUniversity = val,
                    validator: (val) => val == null ? 'مطلوب' : null,
                  ),
                  const SizedBox(height: 16),

                  // College
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'الكلية',
                      labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: _colleges.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontFamily: 'Tajawal')))).toList(),
                    onChanged: (val) => selectedCollege = val,
                    validator: (val) => val == null ? 'مطلوب' : null,
                  ),
                  const SizedBox(height: 16),

                  // Student ID
                  TextFormField(
                    controller: studentIdController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: 'الرقم الجامعي',
                      labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      counterText: '',
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'مطلوب';
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isVerified = true;
                          });
                          Navigator.pop(ctx);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'توثيق',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  displayName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal',
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (isVerified)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 24,
                                  )
                                else
                                  GestureDetector(
                                    onTap: _showVerificationBottomSheet,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.orange.shade200),
                                      ),
                                      child: const Text(
                                        'يحتاج توثيق',
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
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
                        title: 'الدعم والمساعدة',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SupportScreen()),
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
