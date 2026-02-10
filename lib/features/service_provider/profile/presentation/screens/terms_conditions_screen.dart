import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/theme/app_theme.dart';

class ServiceProviderTermsConditionsScreen extends StatelessWidget {
  const ServiceProviderTermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppTheme.textColor,
                size: 18,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          title: const Text(
            'الشروط والأحكام',
            style: TextStyle(
              color: AppTheme.textColor,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'مرحبا بك في تطبيق وصل. استخدامك للتطبيق فإنك توافق على الشروط والأحكام التالية:',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 16,
                        height: 1.6,
                        color: AppTheme.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildSection(
                      '1- استخدام التطبيق:',
                      'يلتزم المستخدم باستخدام التطبيق بشكل قانوني وعدم إساءة استخدام الخدمات المقدمة.',
                    ),
                    _buildSection(
                      '2- إنشاء الحساب:',
                      'يجب على المستخدم إدخال معلومات صحيحة ودقيقة عند تسجيل الحساب ويتحمل مسؤولية تحديثها عند التغيير.',
                    ),
                    _buildSection(
                      '3- الخدمات والحجوزات:',
                      'تم تقديم خدمات النقل من قبل مقدمي الخدمة المسجلين ويكون التطبيق وسيط ربط الطالب بمقدم الخدمة.',
                    ),
                    _buildSection(
                      '4- الإلغاء والاسترداد:',
                      'يخضع إلغاء الحجز لسياسة الإلغاء الخاصة بكل مقدم خدمة، والتي قد تختلف من خدمة لأخرى.',
                    ),
                    _buildSection(
                      '5- الدفع:',
                      'في حال توفر المدفوعات داخل التطبيق، يلتزم المستخدم بسداد الرسوم المقررة للخدمة ولا يتحمل التطبيق اي مسؤولية عن اخطاء الدفع الناتجة عن المستخدم.',
                    ),
                    _buildSection(
                      '6- المسؤولية:',
                      'لا يتحمل التطبيق أي مسؤولية مباشرة أو غير مباشرة عن أي خسائر أو أضرار تنتج عن سوء استخدام الخدمة أو تصرفات مقدم الخدمة.',
                    ),
                    _buildSection(
                      '7- الخصوصية:',
                      'يلتزم التطبيق بخصوصية المستخدم وعدم التعامل مع البيانات وفق سياسة الخصوصية.',
                    ),
                    _buildSection(
                      '8- التعديلات:',
                      'حق لتطبيق تحديث أو تعديل هذه الشروط في أي وقت، وسيتم إشعار المستخدم عند حدوث تغيير.',
                    ),
                  ],
                ),
              ),
            ),
            // Removed duplicated bottom nav as per UX review
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14,
              color: AppTheme.textColor.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
