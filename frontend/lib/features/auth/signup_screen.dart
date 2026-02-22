import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/components/custom_text_field.dart';
import 'package:wasl/core/components/primary_button.dart';
import 'package:wasl/core/theme/app_theme.dart';

class SignUpScreen extends StatefulWidget {
  final String? role;
  const SignUpScreen({super.key, this.role});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  // City controller removed in favor of selection

  final List<String> _saudiCities = [
    'الرياض',
    'جدة',
    'مكة المكرمة',
    'المدينة المنورة',
    'الدمام',
    'الخبر',
    'تبوك',
    'بريدة',
    'عنيزة',
    'حائل',
    'جازان',
    'نجران',
    'أبها',
    'خميس مشيط',
    'الطائف',
    'الجبيل',
    'الخرج',
    'ينبع',
    'الهفوف',
    'المبرز',
    'سكاكا',
    'عرعر',
  ];

  String? _selectedCity;

  // State for selections
  DateTime? _selectedDate;
  String? _selectedGender;
  bool _submitted = false; // Add this to track submission

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1950),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: AppTheme.lightTheme.copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme.copyWith(
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    setState(() {
      _submitted = true;
    });

    // 1.g: One or more mandatory fields are empty -> "Please fill all required fields."
    // We check this by validating the form. If form is invalid because of empty fields, we show the message.
    bool formValid = _formKey.currentState?.validate() ?? false;

    // Check Date and Gender
    bool dateValid = _selectedDate != null;
    bool genderValid = _selectedGender != null;
    
    // ... rest of validation logic matches original structure ...
    if (!formValid || !dateValid || !genderValid) {
      String errorMessage = 'الرجاء تعبئة جميع الحقول المطلوبة.';

      if (!dateValid) {
        errorMessage = 'الرجاء اختيار تاريخ الميلاد.';
      } else if (!genderValid) {
        errorMessage = 'الرجاء اختيار الجنس.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage, textAlign: TextAlign.right),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Success — pass collected data to password screen
    final signupData = {
      'fullName':
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'role': widget.role, // may be null
    };
    context.push('/password', extra: signupData);
  }

  // Validators
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'مطلوب';
    // Letters and spaces (English + Arabic)
    // \u0621-\u064A covers the standard Arabic alphabet.
    // This excludes \u0660-\u0669 (Arabic-Indic digits).
    final nameExp = RegExp(r'^[\u0621-\u064Aa-zA-Z\s]+$');
    if (!nameExp.hasMatch(value)) {
      return 'أحرف فقط';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'مطلوب';
    final emailExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailExp.hasMatch(value)) {
      return 'بريد غير صحيح';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'مطلوب';
    // Starts with 05 and exactly 10 digits
    final phoneExp = RegExp(r'^05[0-9]{8}$');
    if (!phoneExp.hasMatch(value)) {
      return 'رقم غير صحيح';
    }
    return null;
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) return 'مطلوب';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8),
        ],
        leading: null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            // autovalidateMode: AutovalidateMode.onUserInteraction, // Removed to prevent global validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  'إنشاء حساب',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text('تسجيل دخول'),
                      ),
                      Text(
                        'مُسجل بالفعل؟',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Section 1: Personal Info
                _buildSectionHeader(context, 'البيانات الشخصية'),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'الأسم الأخير',
                        hint: 'المقبل',
                        controller: _lastNameController,
                        validator: _validateName,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'الأسم الأول',
                        hint: 'فارس',
                        controller: _firstNameController,
                        validator: _validateName,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Date of Birth & Gender
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Date of Birth
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'تاريخ الميلاد',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                          ),
                          const SizedBox(height: 8),
                            InkWell(
                            onTap: _pickDate,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: (_submitted && _selectedDate == null)
                                      ? Colors.red.withValues(alpha: 0.5)
                                      : Colors.grey.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildDatePart(
                                    _selectedDate?.year.toString() ?? 'سنه',
                                  ),
                                  Text(
                                    '/',
                                    style: TextStyle(color: Colors.grey[300]),
                                  ),
                                  _buildDatePart(
                                    _selectedDate?.month.toString() ?? 'شهر',
                                  ),
                                  Text(
                                    '/',
                                    style: TextStyle(color: Colors.grey[300]),
                                  ),
                                  _buildDatePart(
                                    _selectedDate?.day.toString() ?? 'يوم',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Gender
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'الجنس',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: (_submitted && _selectedGender == null)
                                    ? Colors.red.withValues(alpha: 0.5) // Show red if submitted & empty
                                    : Colors.grey.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildGenderOption(
                                    context,
                                    'أنثى',
                                    'female',
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 24,
                                  color: Colors.grey.withValues(alpha: 0.2),
                                ),
                                Expanded(
                                  child: _buildGenderOption(
                                    context,
                                    'ذكر',
                                    'male',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Section 2: Contact Info
                _buildSectionHeader(context, 'معلومات الاتصال'),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'البريد الالكتروني',
                  hint: 'name@example.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: _validateEmail,
                ),

                const SizedBox(height: 16),
                CustomTextField(
                  label: 'رقم الجوال',
                  hint: '050*******',
                  prefixIcon: Icons.phone_android_rounded,
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  validator: _validatePhone,
                ),

                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction, // Added here
                  initialValue: _selectedCity,
                  items: _saudiCities.map((city) {
                    return DropdownMenuItem(value: city, child: Text(city));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value;
                    });
                  },
                  validator: _validateRequired,
                  decoration: InputDecoration(
                    labelText: 'المدينة',
                    hintText: 'اختر المدينة',
                    prefixIcon: const Icon(Icons.location_city_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                ),

                const SizedBox(height: 48),

                // Next Button
                PrimaryButton(text: 'التالي', onPressed: _submit),

                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'وَصِل',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.2))),
        const SizedBox(width: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePart(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: text.contains(RegExp(r'[0-9]'))
            ? Colors.black87
            : Colors.grey[400],
      ),
    );
  }

  Widget _buildGenderOption(BuildContext context, String label, String value) {
    final isSelected = _selectedGender == value;
    return InkWell(
      onTap: () => setState(() => _selectedGender = value),
      borderRadius: BorderRadius.circular(16),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppTheme.primaryColor : Colors.grey[400],
          ),
        ),
      ),
    );
  }
}
