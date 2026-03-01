import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/core/services/auth_service.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  bool _isLoading = false;

  Future<void> _selectProvider() async {
    setState(() => _isLoading = true);
    try {
      // Switch mode from STUDENT (default) to PROVIDER in the DB
      await AuthService.switchMode();
      if (!mounted) return;
      context.go('/service_provider/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'حدث خطأ أثناء اختيار الدور. الرجاء المحاولة مرة أخرى.',
            textAlign: TextAlign.right,
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'يا هلا بك\nفي وَصل!',
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'منصة متكاملة لربط الطلاب بخدمات\nالنقل والسكن الجامعي',
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.subtitleColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 1),

              Center(
                child: Text(
                  'اختر دورك',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Student Card — no backend call needed (already STUDENT)
              _RoleCard(
                icon: Icons.school_outlined,
                title: 'طالب',
                description: 'ابحث عن خدمات النقل والسكن\nواحجز بسهولة وأمان',
                onTap: _isLoading ? null : () => context.go('/student/home'),
                color: const Color(0xFFE0F2F1), // Very light teal
                contentColor: AppTheme.primaryColor,
              ),

              const SizedBox(height: 16),

              // Service Provider Card — calls switchMode to save PROVIDER in DB
              _RoleCard(
                icon: Icons.car_rental,
                title: 'مقدم خدمة',
                description: 'قدّم خدمات النقل أو السكن\nوأدر حجوزاتك بكفاءة',
                onTap: _isLoading ? null : _selectProvider,
                color: Colors.white,
                contentColor: AppTheme.textColor,
                isOutlined: true,
                isLoading: _isLoading,
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final Color color;
  final Color contentColor;
  final bool isOutlined;
  final bool isLoading;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    required this.color,
    required this.contentColor,
    this.isOutlined = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(24),
      elevation: isOutlined ? 0 : 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: isOutlined
                ? Border.all(color: Colors.grey.withValues(alpha: 0.2))
                : Border.all(color: Colors.transparent),
            boxShadow: isOutlined
                ? []
                : [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isOutlined ? Colors.grey[50] : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: contentColor),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      textAlign: TextAlign.right,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: Colors.grey[400],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
