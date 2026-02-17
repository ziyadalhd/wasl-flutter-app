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

  // Dropdown Values
  String? _selectedUniversity;
  String? _selectedCollege;

  // Validation State
  bool _isFormValid = false;

  final List<String> _universities = [
    'جامعة الملك سعود',
    'جامعة الملك عبدالعزيز',
    'جامعة أم القرى',
    'جامعة الإمام محمد بن سعود الإسلامية',
    'جامعة الأميرة نورة بنت عبدالرحمن',
    'جامعة الملك فهد للبترول والمعادن',
    'جامعة الملك خالد',
    'جامعة طيبة',
    'جامعة القصيم',
    'جامعة الإمام عبدالرحمن بن فيصل',
    'جامعة جازان',
    'جامعة تبوك',
    'جامعة الجوف',
    'جامعة نجران',
    'جامعة الحدود الشمالية',
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
  void initState() {
    super.initState();
    // Add listeners to re-validate form on change
    _studentIdController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _studentIdController.removeListener(_validateForm);
    _studentIdController.dispose();
    super.dispose();
  }

  void _validateForm() {
    // Check values directly to update button state without triggering error messages
    final hasUniversity = _selectedUniversity != null;
    final hasCollege = _selectedCollege != null;
    final hasStudentId = _studentIdController.text.isNotEmpty;

    setState(() {
      _isFormValid = hasUniversity && hasCollege && hasStudentId;
    });
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
                    // autovalidateMode: AutovalidateMode.onUserInteraction, // Removed to prevent global validation
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء اختيار الجامعة';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              _selectedUniversity = val;
                              _validateForm();
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء اختيار الكلية';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              _selectedCollege = val;
                              _validateForm();
                            });
                          },
                        ),
                        
                        const SizedBox(height: 20),

                        // Student ID Field
                        CustomTextField(
                          label: 'الرقم الجامعي',
                          hint: '446*******',
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
                          onPressed: _isFormValid
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    if (context.canPop()) {
                                      context.pop(true);
                                    } else {
                                      context.go('/student/home');
                                    }
                                  }
                                }
                              : null, // Disabled if invalid
                        ),

                        const SizedBox(height: 20),
                        
                      ],
                    ),
                  ),
                ),
              ),
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
    String? Function(String?)? validator,
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
        DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction, // Added here
          initialValue: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red),
            ),
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.withValues(alpha: 0.6),
              fontSize: 14,
              fontFamily: 'Tajawal',
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey,
          ),
          isExpanded: true,
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontSize: 14,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ],
    );
  }
}
