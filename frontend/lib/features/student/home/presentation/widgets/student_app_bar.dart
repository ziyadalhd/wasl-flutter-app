import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/services/auth_service.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/student/profile/presentation/screens/student_profile_screen.dart';

class StudentAppBar extends StatefulWidget implements PreferredSizeWidget {
  const StudentAppBar({super.key});

  @override
  State<StudentAppBar> createState() => _StudentAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _StudentAppBarState extends State<StudentAppBar> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final me = await AuthService.getMe();
      if (mounted) {
        setState(() => _userName = me.user.fullName);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 12.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Profile Info (Start - Right in RTL)
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudentProfileScreen(),
                  ),
                );
                // Reload name when returning from profile (user may have edited it)
                _loadUserName();
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Text(
                        _userName.isNotEmpty ? _userName[0] : '',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _userName.isNotEmpty ? _userName : '...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                          height: 1.2,
                        ),
                      ),
                      Text(
                        'طالب',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Notification Icon (End - Left in RTL)
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.15,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: () {
                  context.push('/notifications');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
