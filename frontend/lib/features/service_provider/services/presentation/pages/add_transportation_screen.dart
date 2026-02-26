import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/service_provider/services/presentation/widgets/custom_text_form_field.dart';
import 'package:wasl/features/service_provider/services/presentation/widgets/custom_dropdown_field.dart';

class AddTransportationScreen extends StatefulWidget {
  const AddTransportationScreen({super.key});

  @override
  State<AddTransportationScreen> createState() =>
      _AddTransportationScreenState();
}

class _AddTransportationScreenState extends State<AddTransportationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text inputs
  final _nameController = TextEditingController();
  final _departureLocationController = TextEditingController(); // mock picker
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _capacityController = TextEditingController();

  // Picked Values
  String? _selectedVehicleType;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;

  // Mock Days selection (could be a custom multi-select in reality)
  final List<String> _selectedDays = [];
  final List<String> _availableDays = [
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _departureLocationController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Custom validation for chips and times
      if (_selectedDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء اختيار يوم واحد على الأقل',
                style: TextStyle(fontFamily: 'Tajawal')),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }
      if (_fromTime == null || _toTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء تحديد وقت البدء والانتهاء',
                style: TextStyle(fontFamily: 'Tajawal')),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      // Form is fully valid
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'تمت العملية بنجاح\nتم ارسال طلب اضافة الخدمه الخاص بك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                  Navigator.of(context).pop(); // go back to previous screen
                },
                child: const Text('حسناً'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context, bool isFrom) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl, // keep picker LTR/RTL depending on locale, usually LTR is fine for time but RTL wraps it
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromTime = picked;
        } else {
          _toTime = picked;
        }
      });
    }
  }

  // Helper widget for form block spacing
  Widget _buildSpacing() => const SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Enforce RTL layout
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Column(
            children: [
              Text(
                'إضافة خدمة',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              Text(
                'نقل جديد', // Subtitle
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.subtitleColor,
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        CustomTextFormField(
                          labelText: 'الأسم',
                          hintText: 'ادخل اسم النقل (مثال: باص الجامعة)',
                          controller: _nameController,
                        ),
                        _buildSpacing(),

                        // Vehicle Type Dropdown
                        CustomDropdownField<String>(
                          labelText: 'نوع المركبة',
                          hintText: 'اختر نوع المركبة',
                          value: _selectedVehicleType,
                          items: const [
                            DropdownMenuItem(
                                value: 'سيارة', child: Text('سيارة')),
                            DropdownMenuItem(
                                value: 'حافلة', child: Text('حافلة')),
                            DropdownMenuItem(value: 'فان', child: Text('فان')),
                          ],
                          onChanged: (val) =>
                              setState(() => _selectedVehicleType = val),
                        ),
                        _buildSpacing(),

                        // Departure Location Picker
                        CustomTextFormField(
                          labelText: 'موقع الانطلاق',
                          hintText: 'حدد الموقع على الخريطة',
                          controller: _departureLocationController,
                          readOnly: true, // make it act like a button
                          suffixIcon: const Icon(Icons.location_on_outlined,
                              color: AppTheme.primaryColor),
                          onTap: () {
                            // Mock Location Picker behavior
                            _departureLocationController.text =
                                'جامعة أم القرى';
                          },
                        ),
                        _buildSpacing(),

                        // Description
                        CustomTextFormField(
                          labelText: 'الوصف',
                          hintText: 'يُسمح الى 150 كلمه',
                          controller: _descriptionController,
                          maxLines: 4,
                        ),
                        _buildSpacing(),

                        // Attachments (Container acting as button)
                        const Text(
                          'المرفقات',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            // TODO: Add file picker logic
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Ink(
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppTheme.inputFillColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.2),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cloud_upload_outlined,
                                    color: AppTheme.primaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'اضغط لرفع الصور (حد أقصى 10-20 MB)',
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 12,
                                    color: AppTheme.subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _buildSpacing(),

                        // Time Availability
                        const Text(
                          'التوفر الزمني',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Days Selection (Mock visual multi-select)
                        const Text(
                          'الايام',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _availableDays.map((day) {
                            final isSelected = _selectedDays.contains(day);
                            return FilterChip(
                              label: Text(
                                day,
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 12,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.textColor,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: AppTheme.primaryColor,
                              checkmarkColor: Colors.white,
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedDays.add(day);
                                  } else {
                                    _selectedDays.remove(day);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        // Time Pickers Row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'من الساعه',
                                    style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () => _selectTime(context, true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 16),
                                      decoration: BoxDecoration(
                                        color: AppTheme.inputFillColor,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _fromTime?.format(context) ??
                                                '--:--',
                                            style: const TextStyle(
                                                color: AppTheme.textColor,
                                                fontFamily: 'Tajawal'),
                                          ),
                                          const Icon(Icons.access_time_rounded,
                                              size: 20,
                                              color: AppTheme.subtitleColor),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'إلى الساعة',
                                    style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () => _selectTime(context, false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 16),
                                      decoration: BoxDecoration(
                                        color: AppTheme.inputFillColor,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _toTime?.format(context) ?? '--:--',
                                            style: const TextStyle(
                                                color: AppTheme.textColor,
                                                fontFamily: 'Tajawal'),
                                          ),
                                          const Icon(Icons.access_time_rounded,
                                              size: 20,
                                              color: AppTheme.subtitleColor),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        _buildSpacing(),

                        // Price and Capacity Row
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomTextFormField(
                                labelText: 'السعر',
                                hintText: '0',
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    'assets/icons/Saudi_Riyal_Symbol.svg.png',
                                    height: 20,
                                    width: 20,
                                    color: AppTheme.subtitleColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: CustomTextFormField(
                                labelText: 'السعة',
                                hintText: 'ركاب',
                                controller: _capacityController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Submit Button (Sticky)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('إرسال'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
