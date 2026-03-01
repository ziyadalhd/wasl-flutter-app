import 'package:flutter/material.dart';
import 'package:wasl/core/services/api_client.dart';
import '../widgets/suspend_action_dialog.dart';

class UserDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  
  const UserDetailsScreen({super.key, required this.user});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late String _status;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _status = widget.user['status'];
  }

  void _showActionDialog() {
    final bool isActive = _status == 'نشط';
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final primaryColor = Theme.of(context).primaryColor;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SuspendActionDialog(
          isActive: isActive,
          userName: widget.user['name'],
          onSubmit: (reason) async {
            setState(() => _isUpdating = true);
            try {
              final userId = widget.user['id'];
              if (isActive) {
                await ApiClient.patch('/api/admin/users/$userId/suspend');
              } else {
                await ApiClient.patch('/api/admin/users/$userId/activate');
              }

              if (!mounted) return;

              setState(() {
                _status = isActive ? 'موقوف' : 'نشط';
                widget.user['status'] = _status;
                _isUpdating = false;
              });

              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isActive
                              ? 'تم إيقاف الحساب بنجاح. السبب: $reason'
                              : 'تم إعادة تفعيل الحساب بنجاح.',
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: primaryColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            } catch (e) {
              if (!mounted) return;
              setState(() => _isUpdating = false);
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text('حدث خطأ أثناء تحديث حالة المستخدم'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = _status == 'نشط';

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المستخدم'),
        leading: BackButton(
          onPressed: () => Navigator.pop(context, widget.user),
        ),
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24.0),
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                  child: Text(
                    (widget.user['name'] ?? '?').toString().isNotEmpty
                        ? widget.user['name'].toString().substring(0, 1)
                        : '?',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.user['name'] ?? '',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.user['role'] ?? ''} | ${widget.user['email'] ?? ''}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.green.withValues(alpha: 0.1)
                        : theme.colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _status,
                    style: TextStyle(
                      color: isActive ? Colors.green.shade700 : theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, thickness: 1),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: Colors.white,
            child: Text(
              'البيانات الأساسية',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          ),
          // Basic Info
          Expanded(
            child: Container(
              color: Colors.white,
              child: _buildBasicInfoTab(theme),
            ),
          ),
        ],
      ),
      
      // Sticky Action Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isUpdating ? null : _showActionDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: isActive ? theme.colorScheme.error : theme.primaryColor,
            ),
            child: _isUpdating
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(
                    isActive ? 'إيقاف الحساب' : 'إعادة تفعيل الحساب',
                    style: const TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
        children: [
        _buildInfoRow('البريد الإلكتروني', widget.user['email'] ?? ''),
        const Divider(height: 32),
        _buildInfoRow('رقم الهاتف', widget.user['phone'] ?? '-'),
        const Divider(height: 32),
        _buildInfoRow('الدور', widget.user['role'] ?? ''),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
