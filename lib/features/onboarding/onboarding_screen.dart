import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/core/components/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: 'حلقة الوصل\nلرحلتك الجامعية',
      description:
          'منصة متكاملة تربطك بكل ما تحتاجه في مسيرتك الجامعية، من سكن ونقل وخدمات طلابية.',
      icon: Icons.school_rounded,
    ),
    OnboardingContent(
      title: 'تنقل بسهولة\nوأمان',
      description:
          'اعثر على أفضل خيارات النقل الجامعي الموثوقة والآمنة التي تناسب جدولك وميزانيتك.',
      icon: Icons.directions_bus_filled_rounded,
    ),
    OnboardingContent(
      title: 'سكن مريح\nيوافق احتياجك',
      description:
          'تصفح خيارات السكن المتنوعة وتواصل مع مقدمي الخدمة مباشرة لضمان راحة بالك.',
      icon: Icons.home_work_rounded,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _contents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation (Skip)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage < _contents.length - 1)
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(
                        'تخطي',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.subtitleColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    const SizedBox(
                      height: 48,
                    ), // Placeholder to keep layout stable
                ],
              ),
            ),

            // Onboarding Content PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _contents.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final content = _contents[index];
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration / Icon Placeholder
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(
                              alpha: 0.05,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            content.icon,
                            size: 120,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Text Content
                        Text(
                          content.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: AppTheme.textColor,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          content.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppTheme.subtitleColor,
                                height: 1.5,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Actions (Dots & Button)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  // Page Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_contents.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppTheme.primaryColor
                              : AppTheme.primaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // Next / Get Started Button
                  PrimaryButton(
                    text: _currentPage == _contents.length - 1
                        ? 'ابدأ رحلتك'
                        : 'التالي',
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final IconData icon;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.icon,
  });
}
