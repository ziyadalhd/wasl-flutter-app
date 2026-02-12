import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/theme/app_theme.dart';

class ServiceProviderManageNotificationsScreen extends StatefulWidget {
  const ServiceProviderManageNotificationsScreen({super.key});

  @override
  State<ServiceProviderManageNotificationsScreen> createState() =>
      _ServiceProviderManageNotificationsScreenState();
}

class _ServiceProviderManageNotificationsScreenState
    extends State<ServiceProviderManageNotificationsScreen> {
  // Local state for toggles
  bool _accountNotifications = true;
  bool _serviceNotifications = true;
  bool _paymentNotifications = true;
  bool _generalAnnouncements = true;
  bool _securityAlerts = true;
  bool _appAlerts = true;

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
            'إدارة الإشعارات',
            style: TextStyle(
              color: AppTheme.textColor,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildNotificationTile(
              title: 'إشعارات الحساب',
              value: _accountNotifications,
              onChanged: (val) => setState(() => _accountNotifications = val),
            ),
            const SizedBox(height: 16),
            _buildNotificationTile(
              title: 'إشعارات الخدمات',
              value: _serviceNotifications,
              onChanged: (val) => setState(() => _serviceNotifications = val),
            ),
            const SizedBox(height: 16),
            _buildNotificationTile(
              title: 'إشعارات الدفع',
              value: _paymentNotifications,
              onChanged: (val) => setState(() => _paymentNotifications = val),
            ),
            const SizedBox(height: 16),
            _buildNotificationTile(
              title: 'إعلانات عامة',
              value: _generalAnnouncements,
              onChanged: (val) => setState(() => _generalAnnouncements = val),
            ),
            const SizedBox(height: 16),
            _buildNotificationTile(
              title: 'إشعارات الأمان',
              value: _securityAlerts,
              onChanged: (val) => setState(() => _securityAlerts = val),
            ),
            const SizedBox(height: 16),
            _buildNotificationTile(
              title: 'تنبيهات التطبيق',
              value: _appAlerts,
              onChanged: (val) => setState(() => _appAlerts = val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF268E82), // Teal color from screenshot
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Icon (Right in RTL)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: 16),

          // Text
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Switch (Left in RTL)
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF80CBC4), // Lighter teal
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
