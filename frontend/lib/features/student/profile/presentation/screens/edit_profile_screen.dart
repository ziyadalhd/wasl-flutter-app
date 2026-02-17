import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/components/custom_text_field.dart';
import 'package:wasl/core/components/primary_button.dart';
import 'package:wasl/core/theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  // late TextEditingController _universityController; // Removed
  late TextEditingController _studentIdController;

  // Mock Data
  String? _selectedCity;
  final List<String> _cities = ['مكة المكرمة', 'جدة', 'الرياض', 'الدمام'];

  String? _selectedUniversity;
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

  String? _selectedCollege;
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
    // Initialize with mock data based on screenshot
    _nameController = TextEditingController(text: 'فارس المقبل');
    _emailController = TextEditingController(text: 'ABC@gmail.com');
    _phoneController = TextEditingController(text: '0530202020');
    // _universityController = TextEditingController(text: 'جامعة أم القرى'); // Removed
    _selectedUniversity = 'جامعة أم القرى';
    _studentIdController = TextEditingController(text: '445******');
    // _selectedCity is initialized at declaration or here
    _selectedCity = 'مكة المكرمة';
    _selectedCollege = 'كلية الحاسب الآلي ونظم المعلومات';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    // _universityController.dispose(); // Removed
    _studentIdController.dispose();
    super.dispose();
  }

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
            'تعديل الملف الشخصي',
            style: TextStyle(
              color: AppTheme.textColor,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            // autovalidateMode: AutovalidateMode.onUserInteraction, // Removed to prevent global validation
            child: Column(
              children: [
                // Name Fields Row
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'الاسم الأول',
                        hint: 'الاسم الأول',
                        controller: TextEditingController(text: 'فارس'),
                        validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                        labelAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'الاسم الأخير',
                        hint: 'الاسم الأخير',
                        controller: TextEditingController(text: 'المقبل'),
                        validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                        labelAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Email
                CustomTextField(
                  label: 'البريد الإلكتروني',
                  hint: 'example@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                  labelAlignment: CrossAxisAlignment.start,
                ),
                const SizedBox(height: 16),

                // Phone
                CustomTextField(
                  label: 'رقم الجوال',
                  hint: '05xxxxxxxx',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                  labelAlignment: CrossAxisAlignment.start,
                ),
                const SizedBox(height: 16),

                // City Dropdown
                _buildDropdownField(
                  label: 'المدينة',
                  value: _selectedCity,
                  items: _cities,
                  onChanged: (val) => setState(() => _selectedCity = val),
                ),
                const SizedBox(height: 16),

                // University Dropdown (Replaces TextField)
                _buildDropdownField(
                  label: 'الجامعة',
                  value: _selectedUniversity,
                  items: _universities,
                  onChanged: (val) => setState(() => _selectedUniversity = val),
                 ),
                const SizedBox(height: 16),

                // College
                _buildDropdownField(
                  label: 'الكلية',
                  value: _selectedCollege,
                  items: _colleges,
                  onChanged: (val) => setState(() => _selectedCollege = val),
                ),
                const SizedBox(height: 16),

                // Student ID
                CustomTextField(
                  label: 'الرقم الجامعي',
                  hint: 'الرقم الجامعي',
                  controller: _studentIdController,
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                  labelAlignment: CrossAxisAlignment.start,
                ),

                const SizedBox(height: 40),

                // Update Button
                PrimaryButton(
                  text: 'تعديل',
                  onPressed: () {
                    if (_selectedUniversity == null) {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'الرجاء اختيار الجامعة',
                            style: TextStyle(fontFamily: 'Tajawal'),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    if (_selectedCollege == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'الرجاء اختيار الكلية',
                            style: TextStyle(fontFamily: 'Tajawal'),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'تم تحديث البيانات بنجاح',
                            style: TextStyle(fontFamily: 'Tajawal'),
                          ),
                          backgroundColor: AppTheme.primaryColor,
                        ),
                      );
                      context.pop();
                    }
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 14,
            fontFamily: 'Tajawal',
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
            child: DropdownButtonFormField<String>( // Changed to DropdownButtonFormField to support validation
              autovalidateMode: AutovalidateMode.onUserInteraction, // Added here
              initialValue: value,
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
