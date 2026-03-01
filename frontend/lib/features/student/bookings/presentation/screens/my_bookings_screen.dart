import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/theme/app_theme.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  String _selectedFilter = 'الكل';
  final List<String> _filters = ['الكل', 'المؤكدة', 'المعلقة', 'المرفوضة'];

  final List<Map<String, dynamic>> _dummyBookings = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
      'title': 'سكن الواجهة',
      'serviceType': 'سكن',
      'status': 'المؤكدة',
      'price': '7500 رس / ترم',
      'featureTags': ['غرفتين', '2 حمام', 'سكن مشترك'],
      'rating': 4.8,
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
      'title': 'باص',
      'serviceType': 'نقل',
      'status': 'المعلقة',
      'price': '1900 رس / ترم',
      'featureTags': ['اقتصادي', 'تكييف مركزي'],
      'rating': 4.5,
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
      'title': 'سكن النور',
      'serviceType': 'سكن',
      'status': 'المرفوضة',
      'price': '8000 رس / ترم',
      'featureTags': ['غرفة مفردة', 'حمام خاص'],
      'rating': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredBookings = _selectedFilter == 'الكل'
        ? _dummyBookings
        : _dummyBookings.where((b) => b['status'] == _selectedFilter).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: AppTheme.textColor,
          title: const Text(
            'حجوزاتي',
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
            SizedBox(
              height: 44,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;
                  return FilterChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: isSelected ? Colors.white : AppTheme.textColor,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: AppTheme.primaryColor,
                    checkmarkColor: Colors.white,
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Colors.grey[200]!,
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredBookings.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      itemCount: filteredBookings.length,
                      itemBuilder: (context, index) {
                        final booking = filteredBookings[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: BookingCard(
                            imageUrl: booking['imageUrl'] as String,
                            title: booking['title'] as String,
                            serviceType: booking['serviceType'] as String,
                            status: booking['status'] as String,
                            price: booking['price'] as String,
                            featureTags: (booking['featureTags'] as List)
                                .cast<String>(),
                            rating: booking['rating'] as double?,
                            onTap: () {
                              if (booking['serviceType'] == 'سكن') {
                                context.push('/housing-details', extra: true);
                              } else {
                                context.push(
                                  '/transport-details',
                                  extra: {
                                    'isFromBookings': true,
                                    'data': booking,
                                  },
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                size: 72,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا توجد حجوزات حالياً',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'لم تقم بأي حجوزات للسكن أو النقل حتى الآن. تصفح الخدمات المتاحة واحجز ما يناسبك.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 15,
                color: AppTheme.subtitleColor,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                context.go('/services');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('استعرض الخدمات'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String serviceType;
  final String status;
  final String price;
  final List<String> featureTags;
  final double? rating;
  final VoidCallback onTap;

  const BookingCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.serviceType,
    required this.status,
    required this.price,
    required this.featureTags,
    this.rating,
    required this.onTap,
  });

  Color get _statusColor {
    switch (status) {
      case 'المؤكدة':
        return AppTheme.primaryColor;
      case 'المعلقة':
        return Colors.orange[600]!;
      case 'المرفوضة':
        return AppTheme.errorColor;
      default:
        return Colors.grey[700]!;
    }
  }

  Color get _statusBgColor {
    switch (status) {
      case 'المؤكدة':
        return AppTheme.primaryColor.withValues(alpha: 0.1);
      case 'المعلقة':
        return Colors.orange[600]!.withValues(alpha: 0.1);
      case 'المرفوضة':
        return AppTheme.errorColor.withValues(alpha: 0.1);
      default:
        return Colors.grey.withValues(alpha: 0.1);
    }
  }

  IconData get _statusIcon {
    switch (status) {
      case 'المؤكدة':
        return Icons.check_circle_rounded;
      case 'المعلقة':
        return Icons.access_time_filled_rounded;
      case 'المرفوضة':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1F24).withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: AppTheme.primaryColor.withValues(alpha: 0.05),
          highlightColor: AppTheme.primaryColor.withValues(alpha: 0.02),
          child: Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(20),
                    ),
                    child: Image.network(
                      imageUrl,
                      width: 125,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 125,
                        color: Colors.grey[100],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            serviceType == 'سكن'
                                ? Icons.home_rounded
                                : Icons.directions_bus_rounded,
                            color: AppTheme.primaryColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            serviceType,
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(width: 1, color: Colors.grey[100]),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppTheme.textColor,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _statusBgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _statusIcon,
                                  size: 12,
                                  color: _statusColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  status,
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: featureTags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الإجمالي',
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  price,
                                  style: const TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 16,
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (rating != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  rating.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
