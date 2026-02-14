import 'package:flutter/material.dart';

import 'package:wasl/features/chat/presentation/widgets/chat_list_item.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحادثات'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          ChatListItem(
            name: 'معاذ بوقس',
            role: 'طالب',
            message: 'هل السكن متوفر طوال الإجازة...',
            imageUrl: '', // Placeholder
            hasWarning: true,
            onTap: () {},
          ),
          ChatListItem(
            name: 'يزن الكمال',
            role: 'طالب',
            message: 'وين مكان السكن بالضبط...',
            imageUrl: '', // Placeholder
            hasWarning: true,
            onTap: () {},
          ),
          ChatListItem(
            name: 'سعود الدهاسي',
            role: 'طالب',
            message: 'بخصوص الدفع متى يكون...',
            imageUrl: '', // Placeholder
            hasWarning: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
