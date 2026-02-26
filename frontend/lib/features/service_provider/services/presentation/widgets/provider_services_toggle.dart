import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';

enum ServiceTab { transportation, accommodation }

class ProviderServicesToggle extends StatelessWidget {
  final ServiceTab activeTab;
  final ValueChanged<ServiceTab> onTabChanged;

  const ProviderServicesToggle({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[200], // Muted background for inactive
        borderRadius: BorderRadius.circular(24), // Pill shape
      ),
      child: Stack(
        children: [
          // Background layout with touch areas
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onTabChanged(ServiceTab.transportation),
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox.expand(),
                ),
              ),
              // Thin vertical separator
              Container(
                width: 1,
                height: 24,
                color: Colors.grey[300],
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onTabChanged(ServiceTab.accommodation),
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
          
          // Animated Selection Pill
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            // Align based on RTL (transportation is first/right, accommodation second/left)
            alignment: activeTab == ServiceTab.transportation
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Foreground Text (Ignore touches)
          IgnorePointer(
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 14,
                        fontWeight: activeTab == ServiceTab.transportation
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: activeTab == ServiceTab.transportation
                            ? Colors.white
                            : AppTheme.subtitleColor,
                      ),
                      child: const Text('النقل'), // Transportation
                    ),
                  ),
                ),
                const SizedBox(width: 1), // Offset for separator space
                Expanded(
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 14,
                        fontWeight: activeTab == ServiceTab.accommodation
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: activeTab == ServiceTab.accommodation
                            ? Colors.white
                            : AppTheme.subtitleColor,
                      ),
                      child: const Text('السكن'), // Accommodation
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
