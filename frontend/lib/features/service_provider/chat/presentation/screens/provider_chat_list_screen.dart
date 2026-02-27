import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/core/widgets/chat/chat_list_card.dart';
import 'package:wasl/features/service_provider/chat/presentation/screens/provider_chat_detail_screen.dart';

class ProviderChatListScreen extends StatelessWidget {
  const ProviderChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'رسائل الطلاب',
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
        itemCount: 2,
        itemBuilder: (context, index) {
          final mockChats = [
            {'name': 'سارة وليد', 'time': 'أمس', 'message': 'نعم، تفضلي بالتواصل معي.'},
            {'name': 'نورة سعد', 'time': 'الأحد', 'message': 'متى يبدأ الحجز؟'},
          ];
          final chat = mockChats[index];
          return ChatListCard(
            name: chat['name']!,
            role: 'طالب', // Hardcoded for Provider's view
            time: chat['time']!,
            message: chat['message']!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProviderChatDetailScreen(
                    studentName: chat['name']!,
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
