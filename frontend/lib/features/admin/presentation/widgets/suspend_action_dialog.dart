import 'package:flutter/material.dart';

class SuspendActionDialog extends StatefulWidget {
  final bool isActive;
  final String userName;
  final Function(String reason) onSubmit;

  const SuspendActionDialog({
    super.key,
    required this.isActive,
    required this.userName,
    required this.onSubmit,
  });

  @override
  State<SuspendActionDialog> createState() => _SuspendActionDialogState();
}

class _SuspendActionDialogState extends State<SuspendActionDialog> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isLoading = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _reasonController.addListener(() {
      setState(() {
        _isButtonEnabled = widget.isActive ? _reasonController.text.trim().isNotEmpty : true;
      });
    });
    
    // If we're reactivating, reason is optional/not needed, button is enabled by default
    if (!widget.isActive) {
      _isButtonEnabled = true;
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      Navigator.of(context).pop();
      widget.onSubmit(_reasonController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.isActive ? 'تنبيه إيقاف الحساب' : 'إعادة تفعيل الحساب',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isActive
                ? 'هل أنت متأكد من رغبتك في إيقاف حساب "${widget.userName}"؟ \nالمستخدم لن يتمكن من تسجيل الدخول أو استخدام التطبيق.'
                : 'هل أنت متأكد من رغبتك في إعادة تفعيل حساب "${widget.userName}"؟',
            style: const TextStyle(color: Colors.grey),
          ),
          if (widget.isActive) ...[
            const SizedBox(height: 24),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'اكتب سبب الإيقاف هنا (إجباري)...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ],
      ),
      actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _isButtonEnabled && !_isLoading ? _handleSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isActive ? theme.colorScheme.error : theme.primaryColor,
                disabledBackgroundColor: Colors.grey.shade300,
                minimumSize: const Size(100, 48), // Ensure size for loading indicator
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'تأكيد',
                      style: TextStyle(
                        color: _isButtonEnabled ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
