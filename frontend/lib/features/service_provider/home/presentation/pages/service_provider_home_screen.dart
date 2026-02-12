import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/service_provider/home/presentation/widgets/service_provider_app_bar.dart';
import 'package:wasl/features/service_provider/home/presentation/widgets/section_header.dart';
import 'package:wasl/features/service_provider/home/presentation/widgets/service_listing_card.dart';
import 'package:wasl/features/service_provider/home/presentation/widgets/service_provider_add_card.dart';
import 'package:wasl/features/service_provider/home/presentation/widgets/dashboard_stat_card.dart';
import 'package:wasl/features/service_provider/home/presentation/widgets/impact_banner.dart';

class ServiceProviderHomeScreen extends StatefulWidget {
  const ServiceProviderHomeScreen({super.key});

  @override
  State<ServiceProviderHomeScreen> createState() => _ServiceProviderHomeScreenState();
}

class _ServiceProviderHomeScreenState extends State<ServiceProviderHomeScreen> {
  int _selectedIndex = 2; // Default to Home (Middle index in 5 items)

  @override
  Widget build(BuildContext context) {
    // Wrap in Directionality to enforce RTL
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const ServiceProviderAppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Current Services Section
              SectionHeader(
                title: 'خدماتي الحالية',
                onViewMore: () {},
              ),
              SizedBox(
                height: 260,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  children: [
                    const SizedBox(width: 16), // Padding start
                    // Add Service Card (First item often or last. Screenshot shows last? No, actually screenshot shows "Add Service" as a card in the grid?
                    // Wait, re-checking screenshot.
                    // Screenshot shows:
                    // Top: "خدماتي الحالية" (My Current Services)
                    // List: [Housing Card (Active)], [Add Service Card (Big +)]
                    // Then Grid of stats.
                    
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
        ),
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
