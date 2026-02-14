import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/student/home/presentation/widgets/student_app_bar.dart';
import 'package:wasl/features/student/home/presentation/widgets/section_header.dart';
import 'package:wasl/features/student/home/presentation/widgets/listing_card.dart';
import 'package:wasl/features/student/home/presentation/widgets/promo_banner.dart';
import 'package:wasl/features/wallet/presentation/screens/student_wallet_screen.dart';
import 'package:wasl/features/chat/presentation/screens/chat_list_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _selectedIndex = 2; // Default to Home

  // Screens for each tab
  final List<Widget> _screens = [
    const StudentWalletScreen(),
    const ChatListScreen(),
    const _StudentHomeBody(),
    const Center(child: Text('الخدمات')), // Placeholder
    const Center(child: Text('حجوزاتي')), // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    // Wrap in Directionality to enforce RTL
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // Only show AppBar on Home tab?
        // The other screens have their own Scaffolds/AppBars.
        // However, we are switching BODIES.
        // If other screens have Scaffolds, we can't nest Scaffolds easily without issues (e.g. double app bars if we keep this one).
        // StudentHomeBody needs this AppBar.
        // Wallet and Chat have their own AppBars in my implementation.
        // So I should ONLY show this Scaffold's AppBar if _selectedIndex == 2.
        appBar: _selectedIndex == 2 ? const StudentAppBar() : null,

        body: _screens[_selectedIndex],

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: Colors.grey[400],
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined),
                activeIcon: Icon(Icons.account_balance_wallet),
                label: 'محفظتي',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                activeIcon: Icon(Icons.chat_bubble),
                label: 'محادثات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_filled),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view),
                activeIcon: Icon(Icons.grid_view_rounded),
                label: 'الخدمات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                activeIcon: Icon(Icons.calendar_today),
                label: 'حجوزاتي',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudentHomeBody extends StatelessWidget {
  const _StudentHomeBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24), // Increased spacing
          // Housing Section
          SectionHeader(
            title: 'السكن',
            onViewMore: () {
              // TODO: Navigate to Housing
            },
          ),
          SizedBox(
            height: 260, // Increased slightly for better shadow clearance
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              children: List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListingCard(
                    imageUrl:
                        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
                    title: 'استديو حديث ${index + 1}',
                    subtitle: '1500 ريال/شهر',
                    tagText: 'حي الجامعة',
                    onTap: () {},
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 24), // Increased spacing
          // Transport Section
          SectionHeader(
            title: 'النقل',
            onViewMore: () {
              // TODO: Navigate to Transport
            },
          ),
          SizedBox(
            height: 250, // Increased slightly
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              children: List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListingCard(
                    imageUrl:
                        'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
                    title: 'باص جامعي ${index + 1}',
                    subtitle: 'رحلة يومية',
                    onTap: () {},
                  ),
                );
              }),
            ),
          ),

          // Promo Banner
          const PromoBanner(),

          const SizedBox(height: 32), // Increased bottom spacing
        ],
      ),
    );
  }
}
