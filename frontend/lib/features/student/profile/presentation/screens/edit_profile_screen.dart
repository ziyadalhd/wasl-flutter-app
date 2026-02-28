import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/components/custom_text_field.dart';
import 'package:wasl/core/components/primary_button.dart';
import 'package:wasl/core/models/models.dart';
import 'package:wasl/core/services/api_client.dart';
import 'package:wasl/core/services/auth_service.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/core/constants/app_constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _studentIdController;

  String? _selectedCity;

  String? _selectedUniversity;
  final List<String> _universities = [
    'جامعة أم القرى',
    'جامعة الملك عبدالعزيز',
    'جامعة الملك سعود',
    'جامعة الملك فهد للبترول والمعادن',
    'جامعة الملك فيصل',
    'جامعة الملك خالد',
    'الجامعة الإسلامية بالمدينة المنورة',
    'جامعة الإمام محمد بن سعود الإسلامية',
    'جامعة طيبة',
    'جامعة القصيم',
    'جامعة حائل',
    'جامعة جازان',
    'جامعة الجوف',
    'جامعة تبوك',
    'جامعة نجران',
    'جامعة الباحة',
    'جامعة الحدود الشمالية',
    'جامعة الأمير سطام بن عبدالعزيز',
    'جامعة شقراء',
    'جامعة المجمعة',
    'جامعة الطائف',
    'جامعة بيشة',
    'جامعة جدة',
    'جامعة حفر الباطن',
    'جامعة الأميرة نورة بنت عبدالرحمن',
    'جامعة الملك سعود بن عبدالعزيز للعلوم الصحية',
    'جامعة الملك عبدالله للعلوم والتقنية',
    'الجامعة السعودية الإلكترونية',
    'جامعة الأمير سلطان',
    'جامعة دار الحكمة',
  ];

  String? _selectedCollege;
  List<String> _colleges = [];

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    _studentIdController = TextEditingController();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Fetch user profile and colleges in parallel
      final results = await Future.wait([
        AuthService.getMe(),
        AuthService.getColleges(),
      ]);

      final meResponse = results[0] as MeResponse;
      final collegesList = results[1] as List<Map<String, dynamic>>;

      final user = meResponse.user;
      final profile = meResponse.profile as StudentProfileDTO?;

      // Split fullName into first and last
      final nameParts = (user.fullName).split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final collegeNames = collegesList.map((c) => c['name'] as String).toList();

      if (mounted) {
        setState(() {
          _firstNameController.text = firstName;
          _lastNameController.text = lastName;
          _emailController.text = user.email;
          _phoneController.text = user.phone ?? '';
          _selectedCity = user.city;
          _selectedUniversity = _universities.contains(profile?.universityName)
              ? profile?.universityName
              : null;
          _studentIdController.text = profile?.universityId ?? '';
          _colleges = collegeNames;

          // Match college from profile
          if (profile?.collegeName != null && collegeNames.contains(profile!.collegeName)) {
            _selectedCollege = profile.collegeName;
          }

          _isLoading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.userMessage, style: const TextStyle(fontFamily: 'Tajawal')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ في تحميل البيانات', style: TextStyle(fontFamily: 'Tajawal')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_selectedCollege == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار الكلية', style: TextStyle(fontFamily: 'Tajawal')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';

      await AuthService.updateProfile({
        'fullName': fullName,
        'phone': _phoneController.text.trim(),
        'city': _selectedCity,
        'universityId': _studentIdController.text.trim(),
        'universityName': _selectedUniversity,
        'collegeName': _selectedCollege,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث البيانات بنجاح', style: TextStyle(fontFamily: 'Tajawal')),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
        context.pop(true); // Return true to indicate changes were saved
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.userMessage, style: const TextStyle(fontFamily: 'Tajawal')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء حفظ البيانات', style: TextStyle(fontFamily: 'Tajawal')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name Fields Row
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'الاسم الأول',
                              hint: 'الاسم الأول',
                              controller: _firstNameController,
                              validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                              labelAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              label: 'الاسم الأخير',
                              hint: 'الاسم الأخير',
                              controller: _lastNameController,
                              validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                              labelAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email (read-only)
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
                      DropdownButtonFormField<String>(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        initialValue: _selectedCity,
                        items: AppConstants.saudiCities.map((city) {
                          return DropdownMenuItem(value: city, child: Text(city));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = value;
                          });
                        },
                        validator: (value) => value == null || value.isEmpty ? 'مطلوب' : null,
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
                      const SizedBox(height: 16),

                      // University Dropdown
                      _buildDropdownField(
                        label: 'الجامعة',
                        value: _selectedUniversity,
                        items: _universities,
                        onChanged: (val) => setState(() => _selectedUniversity = val),
                      ),
                      const SizedBox(height: 16),

                      // College (dynamic from backend)
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
                        isLoading: _isSaving,
                        onPressed: _saveProfile,
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
