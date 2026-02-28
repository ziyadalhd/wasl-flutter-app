import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/components/custom_text_field.dart';
import 'package:wasl/core/components/primary_button.dart';
import 'package:wasl/core/services/api_client.dart';
import 'package:wasl/core/services/auth_service.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/core/constants/app_constants.dart';

class ServiceProviderEditProfileScreen extends StatefulWidget {
  const ServiceProviderEditProfileScreen({super.key});

  @override
  State<ServiceProviderEditProfileScreen> createState() =>
      _ServiceProviderEditProfileScreenState();
}

class _ServiceProviderEditProfileScreenState
    extends State<ServiceProviderEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  String? _selectedCity;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final meResponse = await AuthService.getMe();
      final user = meResponse.user;

      final nameParts = (user.fullName).split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      if (mounted) {
        setState(() {
          _firstNameController.text = firstName;
          _lastNameController.text = lastName;
          _emailController.text = user.email;
          _phoneController.text = user.phone ?? '';
          _selectedCity = user.city;
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
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';

      await AuthService.updateProfile({
        'fullName': fullName,
        'phone': _phoneController.text.trim(),
        'city': _selectedCity,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث البيانات بنجاح', style: TextStyle(fontFamily: 'Tajawal')),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
        context.pop(true);
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
            child: DropdownButton<String>(
              value: value,
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
