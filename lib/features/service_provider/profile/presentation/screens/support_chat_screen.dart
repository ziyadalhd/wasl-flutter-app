import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/theme/app_theme.dart';

class ServiceProviderSupportChatScreen extends StatelessWidget {
  const ServiceProviderSupportChatScreen({super.key});

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
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'الدعم الفني',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.headset_mic_outlined,
                color: AppTheme.textColor,
                size: 24,
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                children: [
                  _buildMessageBubble(
                    message:
                        'اهلا بك في الدعم الفني لتطبيق وصل\nمعك سارة مامور الشكاوي ومقدمي الخدمة',
                    isMe: false,
                  ),
                  _buildMessageBubble(
                    message:
                        'واجهتني مشكله ان الحجز ما يظهر لي في صفحة الإدارة',
                    isMe: true,
                  ),
                  _buildMessageBubble(
                    message:
                        'اهلا بك عزيزي العميل ونعتذر لك عن\nهذا الخطأ التقني الخارج عن ارادتنا\n\nفضلاً قم بتحديث بيانات الحجز وستظهر لك في صفحة\nالحجوزات واذا لم تظهر تواصل معنا مرة اخرى\nوسنقوم بحل الاشكاليه سريعاً باذن الله\n\nنشكر لك رأيك يهمنا ويسعدنا خدمتك',
                    isMe: false,
                  ),
                  _buildMessageBubble(
                    message: 'تحدث الغريب ان يشارِك العهد وما يطولنا',
                    isMe: true,
                  ),
                ],
              ),
            ),
            _buildMessageInput(context),
            // Bottom Navigation Bar Placeholder for verify compliance
            // Using same widget as other screens to keep visual consistency
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble({required String message, required bool isMe}) {
    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isMe
              ? const Color(0xFF00796B)
              : Colors.white, // Dark Green for Me, White for Support
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? Radius.zero : const Radius.circular(16),
            bottomRight: isMe ? const Radius.circular(16) : Radius.zero,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              // Small Support Icon
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Icon(
                  Icons.support_agent,
                  size: 12,
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.white : AppTheme.textColor,
                  fontFamily: 'Tajawal',
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      color: AppTheme.backgroundColor,
      child: Row(
        children: [
          // Send Button
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1), // Light Teal
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 12),
          // Input Field
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'اكتب رسالتك هنا',
                  hintStyle: TextStyle(
                    color: Colors.grey.withValues(alpha: 0.6),
                    fontFamily: 'Tajawal',
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
