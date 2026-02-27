import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/service_provider/services/presentation/widgets/provider_services_toggle.dart';
import 'package:wasl/features/service_provider/services/presentation/widgets/provider_add_service_button.dart';
import 'package:wasl/features/service_provider/services/presentation/widgets/provider_service_card.dart';
import 'package:wasl/features/service_provider/services/presentation/pages/add_accommodation_screen.dart';
import 'package:wasl/features/service_provider/services/presentation/pages/add_transportation_screen.dart';

class ProviderServicesScreen extends StatefulWidget {
  const ProviderServicesScreen({super.key});

  @override
  State<ProviderServicesScreen> createState() => _ProviderServicesScreenState();
}

class _ProviderServicesScreenState extends State<ProviderServicesScreen> {
  ServiceTab _activeTab = ServiceTab.accommodation;

  @override
  Widget build(BuildContext context) {
    // Dynamic text for the Action Button
    final String addServiceText = _activeTab == ServiceTab.accommodation
        ? '+ أضف خدمة سكن جديدة'
        : '+ أضف خدمة نقل جديدة';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0,
          title: const Text(
            'الخدمات',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          centerTitle: false, // Align to the right (due to RTL)
        ),
        body: Column(
          children: [
            // Segmented Control (Toggle)
            ProviderServicesToggle(
              activeTab: _activeTab,
              onTabChanged: (tab) {
                setState(() {
                  _activeTab = tab;
                });
              },
            ),

            // Action Button
            ProviderAddServiceButton(
              text: addServiceText,
              onPressed: () {
                if (_activeTab == ServiceTab.accommodation) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddAccommodationScreen(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddTransportationScreen(),
                    ),
                  );
                }
              },
            ),

            // Content Area (Service Cards List)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                itemCount: 3, // Mock data count
                itemBuilder: (context, index) {
                  // Display mock data based on the selected tab
                  if (_activeTab == ServiceTab.accommodation) {
                    return const ProviderServiceCard(
                      imageUrl:
                          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
                      title: 'سكن النخبة',
                      location: 'حي العوالي',
                      price: '7500 ريال/الترم',
                      rating: 4.8,
                      features: ['سكن مشترك', '2 حمام', 'غرفتين'],
                    );
                  } else {
                    return ProviderServiceCard(
                      imageUrl:
                          'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
                      title: 'توصيل جامعي سريع',
                      location: 'مكة المكرمة',
                      price: '400 ريال/شهرياً',
                      rating: 4.9,
                      features: const [], // Empty features
                      origin: 'الشرائع',
                      destination: 'جامعة أم القرى - العابدية',
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
