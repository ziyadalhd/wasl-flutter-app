import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/core/widgets/chat/chat_bubble.dart';
import 'package:wasl/core/widgets/chat/chat_input_field.dart';

class ProviderChatDetailScreen extends StatelessWidget {
  final String studentName;

  const ProviderChatDetailScreen({
    super.key,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          shadowColor: Colors.black.withValues(alpha: 0.05),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textColor, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    studentName.isNotEmpty ? studentName.substring(0, 1) : '',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studentName,
                    style: const TextStyle(
                      color: AppTheme.textColor,
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'طالب',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontFamily: 'Tajawal',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                reverse: true, // Start from bottom
                children: [
                  const ChatBubble(message: 'حياك الله، نعم متاح.', isMe: true, time: '10:35 ص'),
                  const ChatBubble(message: 'السلام عليكم، هل السكن الخاص بك متاح؟', isMe: false, time: '10:30 ص'),
                ],
              ),
            ),
            const ChatInputField(),
          ],
        ),
      ),
    );
  }
}
