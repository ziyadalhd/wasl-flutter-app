import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/core/components/custom_text_field.dart';
import 'package:wasl/features/student/services/presentation/widgets/housing_card.dart';
import 'package:wasl/features/student/services/presentation/widgets/transport_card.dart';
import 'package:wasl/features/service_provider/services/presentation/widgets/provider_services_toggle.dart';

class ServicesScreen extends StatefulWidget {
  final ServiceTab initialTab;

  const ServicesScreen({super.key, this.initialTab = ServiceTab.accommodation});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late ServiceTab _activeTab;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
  }

  @override
  void didUpdateWidget(ServicesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != oldWidget.initialTab) {
      setState(() {
        _activeTab = widget.initialTab;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: AppTheme.textColor,
          title: const Text(
            'الخدمات',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            ProviderServicesToggle(
              activeTab: _activeTab,
              onTabChanged: (tab) {
                setState(() {
                  _activeTab = tab;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: CustomTextField(
                controller: _searchController,
                hint: 'ابحث هنا...',
                prefixIcon: Icons.search,
              ),
            ),
            Expanded(
              child: _activeTab == ServiceTab.accommodation
                  ? _buildHousingGrid()
                  : _buildTransportList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHousingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return HousingCard(
          imageUrl:
              'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
          title: 'سكن الواجهة',
          location: 'حي الشوقية',
          price: '7500 رس / ترم',
          featureTags: const ['غرفتين', '2 حمام', 'سكن مشترك'],
          rating: 4.8,
          availability: '1/2',
          onTap: () {
            context.push('/housing-details');
          },
        );
      },
    );
  }

  final List<Map<String, dynamic>> _transportData = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
      'title': 'باص',
      'route': 'الشوقية ← جامعة أم القرى الزاهر',
      'price': '1900 رس / ترم',
      'featureTags': ['اقتصادي', 'تكييف مركزي'],
      'rating': 4.5,
      'availability': '12/35',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
      'title': 'سيارة خاصة',
      'route': 'العوالي ← جامعة أم القرى العابدية',
      'price': '3000 رس / ترم',
      'featureTags': ['سريع', 'خصوصية', 'مكيف'],
      'rating': 4.9,
      'availability': '2/4',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1519003722824-194d4455a60c?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
      'title': 'فان عائلي',
      'route': 'العتيبية ← جامعة أم القرى الزاهر',
      'price': '2200 رس / ترم',
      'featureTags': ['مريح', 'مساحة واسعة'],
      'rating': 4.7,
      'availability': '3/7',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
      'title': 'باص',
      'route': 'الشرائع ← جامعة أم القرى العابدية',
      'price': '1800 رس / ترم',
      'featureTags': ['اقتصادي', 'واي فاي'],
      'rating': 4.3,
      'availability': '20/45',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
      'title': 'سيارة خاصة',
      'route': 'الشوقية ← جامعة أم القرى العابدية',
      'price': '2800 رس / ترم',
      'featureTags': ['سريع', 'مكيف'],
      'rating': 4.8,
      'availability': '1/4',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1519003722824-194d4455a60c?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
      'title': 'فان عائلي',
      'route': 'العوالي ← جامعة أم القرى الزاهر',
      'price': '2400 رس / ترم',
      'featureTags': ['مريح', 'تكييف مركزي'],
      'rating': 4.6,
      'availability': '5/7',
    },
  ];

  Widget _buildTransportList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _transportData.length,
      itemBuilder: (context, index) {
        final data = _transportData[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TransportCard(
            imageUrl: data['imageUrl'],
            title: data['title'],
            route: data['route'],
            price: data['price'],
            featureTags: List<String>.from(data['featureTags']),
            rating: data['rating'],
            availability: data['availability'],
            onTap: () {
              context.push('/transport-details', extra: data);
            },
          ),
        );
      },
    );
  }
}
