import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/service_provider/services/presentation/widgets/custom_text_form_field.dart';
import 'package:wasl/features/service_provider/services/presentation/widgets/custom_dropdown_field.dart';
import 'package:wasl/core/constants/app_constants.dart';

class AddAccommodationScreen extends StatefulWidget {
  const AddAccommodationScreen({super.key});

  @override
  State<AddAccommodationScreen> createState() => _AddAccommodationScreenState();
}

class _AddAccommodationScreenState extends State<AddAccommodationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text inputs
  final _nameController = TextEditingController();
  final _locationController = TextEditingController(); // acts as mock picker
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  // Dropdown values
  String? _selectedCity;
  String? _selectedAccommodationType;
  int? _selectedRooms;
  int? _selectedBathrooms;
  int? _selectedFacilities;
  String? _selectedCapacity; // Changed from controller to dropdown value

  // Subscription state
  String? _selectedDuration;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDuration == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء اختيار مدة الاشتراك',
                style: TextStyle(fontFamily: 'Tajawal')),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء تحديد تاريخ الاشتراك',
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  Widget _buildRadioOption(String title, String value, String? groupValue, ValueChanged<String?> onChanged) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: AppTheme.subtitleColor,
      ),
      child: RadioListTile<String>(
        title: Text(title, style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.w600)),
        value: value,
        groupValue: groupValue,
        activeColor: AppTheme.primaryColor,
        contentPadding: EdgeInsets.zero,
        dense: true,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSubscriptionDetailsBlock({
    required TextEditingController priceController,
    required DateTime? startDate,
    required DateTime? endDate,
    required Function(DateTime) onStartDatePicked,
    required Function(DateTime) onEndDatePicked,
    EdgeInsets? padding,
  }) {
    return Container(
      margin: padding ?? EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor, 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          CustomTextFormField(
            labelText: 'السعر',
            hintText: 'أدخل السعر',
            controller: priceController,
            keyboardType: TextInputType.number,
            suffixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                'assets/icons/Saudi_Riyal_Symbol.svg.png',
                height: 20,
                width: 20,
                color: AppTheme.subtitleColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDatePickerField('تاريخ البداية', startDate, onStartDatePicked),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDatePickerField('تاريخ النهاية', endDate, onEndDatePicked),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerField(String label, DateTime? date, Function(DateTime) onPicked) {
    return FormField<DateTime>(
      initialValue: date,
      validator: (val) => val == null ? 'مطلوب' : null,
      builder: (FormFieldState<DateTime> state) {
        final dateStr = state.value != null 
            ? "${state.value!.year}-${state.value!.month.toString().padLeft(2, '0')}-${state.value!.day.toString().padLeft(2, '0')}" 
            : 'اختر التاريخ';
        final hasError = state.hasError;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: state.value ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
                );
                if (picked != null) {
                  state.didChange(picked);
                  onPicked(picked);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: AppTheme.inputFillColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: hasError ? AppTheme.errorColor : Colors.transparent,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        dateStr,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 13,
                          color: state.value != null ? AppTheme.textColor : AppTheme.subtitleColor,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_outlined, 
                      size: 18, 
                      color: hasError ? AppTheme.errorColor : AppTheme.primaryColor
                    ),
                  ],
                ),
              ),
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 8),
                child: Text(
                  state.errorText!, 
                  style: const TextStyle(color: AppTheme.errorColor, fontSize: 12, fontFamily: 'Tajawal')
                ),
              ),
          ],
        );
      }
    );
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
                'سكن جديد', // Subtitle
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
                          hintText: 'ادخل اسم السكن',
                          controller: _nameController,
                        ),
                        _buildSpacing(),

                        // Accommodation Type Dropdown
                        CustomDropdownField<String>(
                          labelText: 'نوع السكن',
                          hintText: 'اختر نوع السكن',
                          value: _selectedAccommodationType,
                          items: const [
                            DropdownMenuItem(value: 'شقة', child: Text('شقة')),
                            DropdownMenuItem(
                                value: 'استديو', child: Text('استديو')),
                            DropdownMenuItem(
                                value: 'غرفة مشتركة',
                                child: Text('غرفة مشتركة')),
                          ],
                          onChanged: (val) => setState(
                              () => _selectedAccommodationType = val),
                        ),
                        _buildSpacing(),

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
                        _buildSpacing(),

                        // Location Picker (Mock via Text Input + Icon for now)
                        CustomTextFormField(
                          labelText: 'الموقع',
                          hintText: 'حدد الموقع على الخريطة',
                          controller: _locationController,
                          readOnly: true, // make it act like a button
                          suffixIcon: const Icon(Icons.location_on_outlined,
                                color: AppTheme.primaryColor),
                          onTap: () {
                            // Mock Location Picker behavior
                            _locationController.text = 'حي العوالي، مكة';
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

                        // Old attachments location removed.


                        // Rooms & Facilities Multi-column Row
                        const Text(
                          'عدد الغرف والمرافق',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: CustomDropdownField<int>(
                                labelText: 'غرف',
                                value: _selectedRooms,
                                items: List.generate(
                                    5,
                                    (i) => DropdownMenuItem(
                                        value: i + 1, child: Text('${i + 1}'))),
                                onChanged: (val) =>
                                    setState(() => _selectedRooms = val),
                                validator: (val) => val == null ? 'مطلوب' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomDropdownField<int>(
                                labelText: 'دورات مياه',
                                value: _selectedBathrooms,
                                items: List.generate(
                                    5,
                                    (i) => DropdownMenuItem(
                                        value: i + 1, child: Text('${i + 1}'))),
                                onChanged: (val) =>
                                    setState(() => _selectedBathrooms = val),
                                validator: (val) => val == null ? 'مطلوب' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomDropdownField<int>(
                                labelText: 'مرافق',
                                value: _selectedFacilities,
                                items: List.generate(
                                    5,
                                    (i) => DropdownMenuItem(
                                        value: i, child: Text('$i'))),
                                onChanged: (val) =>
                                    setState(() => _selectedFacilities = val),
                                validator: (val) => val == null ? 'مطلوب' : null,
                              ),
                            ),
                          ],
                        ),
                        _buildSpacing(),

                        // Capacity Dropdown (Moved out of Price row)
                        CustomDropdownField<String>(
                          labelText: 'السعة',
                          hintText: 'اختر السعة',
                          value: _selectedCapacity,
                          items: const [
                            DropdownMenuItem(value: '1', child: Text('1 أفراد')),
                            DropdownMenuItem(value: '2', child: Text('2 أفراد')),
                            DropdownMenuItem(value: '3', child: Text('3 أفراد')),
                            DropdownMenuItem(value: '4', child: Text('4 أفراد')),
                          ],
                          onChanged: (val) => setState(() => _selectedCapacity = val),
                        ),
                        _buildSpacing(),

                        // Subscription Duration Section
                        const Text(
                          'مدة الاشتراك',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'اختر مدة واحدة فقط للاشتراك',
                          style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: AppTheme.subtitleColor),
                        ),
                        const SizedBox(height: 12),
                        _buildRadioOption('شهري', 'شهري', _selectedDuration, (val) => setState(() => _selectedDuration = val)),
                        _buildRadioOption('ترم', 'ترم', _selectedDuration, (val) => setState(() => _selectedDuration = val)),
                        _buildRadioOption('سنة دراسية كاملة', 'سنة دراسية كاملة', _selectedDuration, (val) => setState(() => _selectedDuration = val)),
                        
                        if (_selectedDuration != null) ...[
                          const SizedBox(height: 16),
                          _buildSubscriptionDetailsBlock(
                            priceController: _priceController,
                            startDate: _startDate,
                            endDate: _endDate,
                            onStartDatePicked: (date) => setState(() => _startDate = date),
                            onEndDatePicked: (date) => setState(() => _endDate = date),
                          ),
                        ],
                        _buildSpacing(),

                        // Attachments (Moved to Bottom)
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
                            height: 80, // Slightly taller for better touch target
                            decoration: BoxDecoration(
                              color: AppTheme.inputFillColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.2),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start, // RTL -> right aligned
                                    children: [
                                      Text(
                                        'صور السكن',
                                        style: TextStyle(
                                          fontFamily: 'Tajawal',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textColor,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'اضغط لرفع الملف (PNG, JPG)',
                                        style: TextStyle(
                                          fontFamily: 'Tajawal',
                                          fontSize: 12,
                                          color: AppTheme.subtitleColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.cloud_upload_outlined,
                                      color: AppTheme.primaryColor, size: 28),
                                ],
                              ),
                            ),
                          ),
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
