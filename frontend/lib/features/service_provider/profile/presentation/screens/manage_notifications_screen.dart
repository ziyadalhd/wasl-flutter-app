import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasl/core/theme/app_theme.dart';

class ServiceProviderManageNotificationsScreen extends StatefulWidget {
  const ServiceProviderManageNotificationsScreen({super.key});

  @override
  State<ServiceProviderManageNotificationsScreen> createState() =>
      _ServiceProviderManageNotificationsScreenState();
}

class _ServiceProviderManageNotificationsScreenState
    extends State<ServiceProviderManageNotificationsScreen> {
  // Keys for SharedPreferences (provider-prefixed)
  static const _keyAccount = 'notif_provider_account';
  static const _keyService = 'notif_provider_service';
  static const _keyPayment = 'notif_provider_payment';
  static const _keyGeneral = 'notif_provider_general';
  static const _keySecurity = 'notif_provider_security';
  static const _keyApp = 'notif_provider_app';

  bool _accountNotifications = true;
  bool _serviceNotifications = true;
  bool _paymentNotifications = true;
  bool _generalAnnouncements = true;
  bool _securityAlerts = true;
  bool _appAlerts = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _accountNotifications = prefs.getBool(_keyAccount) ?? true;
        _serviceNotifications = prefs.getBool(_keyService) ?? true;
        _paymentNotifications = prefs.getBool(_keyPayment) ?? true;
        _generalAnnouncements = prefs.getBool(_keyGeneral) ?? true;
        _securityAlerts = prefs.getBool(_keySecurity) ?? true;
        _appAlerts = prefs.getBool(_keyApp) ?? true;
        _isLoading = false;
      });
    }
  }

  Future<void> _savePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildNotificationTile(
                    title: 'إشعارات الحساب',
                    value: _accountNotifications,
                    onChanged: (val) {
                      setState(() => _accountNotifications = val);
                      _savePreference(_keyAccount, val);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationTile(
                    title: 'إشعارات الخدمات',
                    value: _serviceNotifications,
                    onChanged: (val) {
                      setState(() => _serviceNotifications = val);
                      _savePreference(_keyService, val);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationTile(
                    title: 'إشعارات الدفع',
                    value: _paymentNotifications,
                    onChanged: (val) {
                      setState(() => _paymentNotifications = val);
                      _savePreference(_keyPayment, val);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationTile(
                    title: 'إعلانات عامة',
                    value: _generalAnnouncements,
                    onChanged: (val) {
                      setState(() => _generalAnnouncements = val);
                      _savePreference(_keyGeneral, val);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationTile(
                    title: 'إشعارات الأمان',
                    value: _securityAlerts,
                    onChanged: (val) {
                      setState(() => _securityAlerts = val);
                      _savePreference(_keySecurity, val);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationTile(
                    title: 'تنبيهات التطبيق',
                    value: _appAlerts,
                    onChanged: (val) {
                      setState(() => _appAlerts = val);
                      _savePreference(_keyApp, val);
                    },
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
        color: const Color(0xFF268E82),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
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
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF80CBC4),
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
