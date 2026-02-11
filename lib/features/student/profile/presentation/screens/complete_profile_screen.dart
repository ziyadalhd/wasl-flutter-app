import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wasl/core/components/primary_button.dart';
import 'package:wasl/core/components/custom_text_field.dart';
import 'package:wasl/core/theme/app_theme.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _studentIdController = TextEditingController();

  // Dropdown Values (Mock Data)
  String? _selectedUniversity;
  String? _selectedCollege;

  final List<String> _universities = [
    'جامعة أم القرى',
    'جامعة الملك عبدالعزيز',
    'جامعة الملك سعود',
    'جامعة جدة',
  ];

  final List<String> _colleges = [
    'كلية الحاسب الآلي ونظم المعلومات',
    'كلية الهندسة',
    'كلية الطب',
    'كلية إدارة الأعمال',
    'كلية الشريعة',
    'كلية العلوم التطبيقية',
    'كلية التربية',
    'كلية الآداب',
    'كلية الأنظمة',
  ];

  @override
  void dispose() {
    _studentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),

                        // 1. Title
                        Text(
                          'إكمال الملف الشخصي',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textColor,
                              ),
                        ),

                        const SizedBox(height: 30),

                        // 2. Logo (Big "Wasl" text)
                        // Using Text as existing assets are not clear, but trying to match style from Splash
                        Text(
                          'وَصِل.',
                          style: GoogleFonts.tajawal(
                            fontSize: 80,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primaryColor,
                            height: 1.0,
                          ),
                        ),

                        const SizedBox(height: 50),

                        // 3. Form Fields

                        // University Dropdown
                        _buildDropdownField(
                          label: 'الجامعة',
                          value: _selectedUniversity,
                          items: _universities,
                          hint: 'اختر الجامعة',
                          onChanged: (val) {
                            setState(() {
                              _selectedUniversity = val;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        // College Dropdown
                        _buildDropdownField(
                          label: 'الكلية',
                          value: _selectedCollege,
                          items: _colleges,
                          hint: 'اختر الكلية',
                          onChanged: (val) {
                            setState(() {
                              _selectedCollege = val;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        // Student ID Field
                        CustomTextField(
                          label: 'الرقم الجامعي',
                          hint:
                              '446*******', // Matching screenshot placeholder style
                          controller: _studentIdController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال الرقم الجامعي';
                            }
                            return null;
                          },
                          labelAlignment: CrossAxisAlignment.start,
                        ),

                        const SizedBox(height: 40),

                        // 4. Action Button
                        PrimaryButton(
                          text: 'إكمال',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // If we were pushed here (from Profile), pop with result true
                              if (context.canPop()) {
                                context.pop(true);
                              } else {
                                // Fallback if navigated directly or differently
                                context.go('/student/home');
                              }
                            }
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // 5. Custom Static Bottom Nav Bar (Visual Only for this screen as per request)
              // Removed as part of UX review to avoid duplicate nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint,
                style: TextStyle(
                  color: Colors.grey.withValues(alpha: 0.6),
                  fontSize: 14,
                  fontFamily: 'Tajawal',
                ),
              ),
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey,
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              borderRadius: BorderRadius.circular(16),
              dropdownColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
