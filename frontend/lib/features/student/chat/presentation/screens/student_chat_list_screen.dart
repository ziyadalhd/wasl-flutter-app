import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/core/widgets/chat/chat_list_card.dart';
import 'package:wasl/features/student/chat/presentation/screens/student_chat_detail_screen.dart';

class StudentChatListScreen extends StatelessWidget {
  const StudentChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'محادثاتي',
          style: TextStyle(
            color: AppTheme.textColor,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemCount: 3,
        itemBuilder: (context, index) {
          final mockChats = [
            {'name': 'أحمد محمد', 'time': '10:30 ص', 'message': 'السلام عليكم، هل السكن متاح؟'},
            {'name': 'خالد عبدالله', 'time': 'الإثنين', 'message': 'شكراً لك.'},
            {'name': 'شركة مساكن', 'time': 'الأحد', 'message': 'تم تأكيد الحجز.'},
          ];
          final chat = mockChats[index];
          return ChatListCard(
            name: chat['name']!,
            role: 'مقدم خدمة', // Hardcoded for Student's view
            time: chat['time']!,
            message: chat['message']!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentChatDetailScreen(
                    providerName: chat['name']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
