import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/service_provider/home/presentation/widgets/service_provider_app_bar.dart';
import 'package:wasl/features/service_provider/home/presentation/widgets/section_header.dart';
import 'package:wasl/features/service_provider/home/presentation/widgets/service_listing_card.dart';
import 'package:wasl/features/service_provider/home/presentation/widgets/service_provider_add_card.dart';
import 'package:wasl/features/service_provider/home/presentation/widgets/dashboard_stat_card.dart';
import 'package:wasl/features/service_provider/home/presentation/widgets/impact_banner.dart';
import 'package:wasl/features/wallet/presentation/screens/provider_wallet_screen.dart';
import 'package:wasl/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:wasl/features/service_provider/services/presentation/pages/provider_services_screen.dart';

class ServiceProviderHomeScreen extends StatefulWidget {
  const ServiceProviderHomeScreen({super.key});

  @override
  State<ServiceProviderHomeScreen> createState() =>
      _ServiceProviderHomeScreenState();
}

class _ServiceProviderHomeScreenState extends State<ServiceProviderHomeScreen> {
  int _selectedIndex = 2; // Default to Home (Middle index in 5 items)

  final List<Widget> _screens = [
    const ProviderWalletScreen(),
    const ChatListScreen(),
    const _ServiceProviderHomeBody(),
    const ProviderServicesScreen(),
    const Center(child: Text('لوحة المعلومات')), // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    // Wrap in Directionality to enforce RTL
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _selectedIndex == 2 ? const ServiceProviderAppBar() : null,
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
              // Dashboard replaced "My Bookings"
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard_rounded),
                label: 'لوحة المعلومات',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceProviderHomeBody extends StatelessWidget {
  const _ServiceProviderHomeBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Current Services Section
          SectionHeader(title: 'خدماتي الحالية', onViewMore: () {}),
          SizedBox(
            height: 260,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              children: [
                const SizedBox(width: 16), // Padding start
                ServiceListingCard(
                  imageUrl:
                      'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
                  title: 'سكن فاخر - حي النخيل',
                  subtitle: '7500 ريال/شهرياً',
                  tagText: 'نشط',
                  tagColor: Colors.green, // Active status
                  onTap: () {},
                ),
                ServiceProviderAddCard(
                  label: 'إضافة خدمة',
                  onTap: () {
                    // TODO: Handle Add Service
                  },
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Dashboard / Stats Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.4, // Adjust for card shape
              children: const [
                DashboardStatCard(
                  icon: Icons.calendar_month_outlined,
                  label: 'إجمالي الحجوزات:',
                  value: '120',
                  iconColor: AppTheme.primaryColor,
                ),
                DashboardStatCard(
                  icon: Icons.campaign_outlined,
                  label: 'إعلانات نشطة:',
                  value: '5',
                  iconColor: AppTheme.primaryColor,
                ),
                DashboardStatCard(
                  icon: Icons.visibility_outlined,
                  label: 'عدد المشاهدات:',
                  value: '3500',
                  iconColor: AppTheme.primaryColor,
                ),
                DashboardStatCard(
                  icon: Icons.star_rate_rounded, // or star_half
                  label: 'التقييم العام:',
                  value: '4.8/5',
                  iconColor: AppTheme.primaryColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Impact Banner
          const ImpactBanner(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
