import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/service_provider/services/presentation/widgets/custom_text_form_field.dart';
import 'package:wasl/features/service_provider/services/presentation/widgets/custom_dropdown_field.dart';
import 'package:wasl/core/constants/app_constants.dart';

class ProviderEditServiceScreen extends StatefulWidget {
  final String serviceType; // 'accommodation' or 'transportation'

  const ProviderEditServiceScreen({
    super.key,
    this.serviceType = 'accommodation',
  });

  @override
  State<ProviderEditServiceScreen> createState() => _ProviderEditServiceScreenState();
}

class _ProviderEditServiceScreenState extends State<ProviderEditServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
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
                'تمت العملية بنجاح\nتم تحديث بيانات الخدمة',
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
                  Navigator.of(context).pop(); // go back to details
                },
                child: const Text('حسناً'),
              ),
            ],
          ),
        );
      },
    );
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'تعديل الخدمة',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
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
                    child: widget.serviceType == 'transportation'
                        ? const _EditTransportForm()
                        : const _EditAccommodationForm(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('حفظ التعديلات'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// ACCOMMODATION FORM WIDGET
// ---------------------------------------------------------
class _EditAccommodationForm extends StatefulWidget {
  const _EditAccommodationForm();

  @override
  State<_EditAccommodationForm> createState() => _EditAccommodationFormState();
}

class _EditAccommodationFormState extends State<_EditAccommodationForm> {
  final _nameController = TextEditingController(text: 'سكن النخبة');
  final _locationController = TextEditingController(text: 'حي العوالي، مكة');
  final _descriptionController = TextEditingController(text: 'سكن مميز بالقرب من الجامعة، شامل جميع الخدمات من إنترنت وكهرباء ونظافة أسبوعية.');
  final _priceController = TextEditingController(text: '7500');

  String? _selectedCity = 'مكة المكرمة';
  String? _selectedAccommodationType = 'شقة';
  int? _selectedRooms = 2;
  int? _selectedBathrooms = 2;
  int? _selectedFacilities = 3;
  String? _selectedCapacity = '2';

  String? _selectedDuration = 'ترم';
  DateTime? _startDate = DateTime.now().add(const Duration(days: 10));
  DateTime? _endDate = DateTime.now().add(const Duration(days: 120));

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
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
              style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textColor),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: state.value ?? DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
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
                  border: Border.all(color: hasError ? AppTheme.errorColor : Colors.transparent),
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
                    Icon(Icons.calendar_today_outlined, size: 18, color: hasError ? AppTheme.errorColor : AppTheme.primaryColor),
                  ],
                ),
              ),
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 8),
                child: Text(state.errorText!, style: const TextStyle(color: AppTheme.errorColor, fontSize: 12, fontFamily: 'Tajawal')),
              ),
          ],
        );
      }
    );
  }

  Widget _buildRadioOption(String title, String value, String? groupValue, ValueChanged<String?> onChanged) {
    return Theme(
      data: Theme.of(context).copyWith(unselectedWidgetColor: AppTheme.subtitleColor),
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

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(height: 20);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          labelText: 'الأسم',
          hintText: 'ادخل اسم السكن',
          controller: _nameController,
        ),
        spacing,

        CustomDropdownField<String>(
          labelText: 'نوع السكن',
          hintText: 'اختر نوع السكن',
          value: _selectedAccommodationType,
          items: const [
            DropdownMenuItem(value: 'شقة', child: Text('شقة')),
            DropdownMenuItem(value: 'استديو', child: Text('استديو')),
            DropdownMenuItem(value: 'غرفة مشتركة', child: Text('غرفة مشتركة')),
          ],
          onChanged: (val) => setState(() => _selectedAccommodationType = val),
        ),
        spacing,

        DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: _selectedCity,
          items: AppConstants.saudiCities.map((city) {
            return DropdownMenuItem(value: city, child: Text(city));
          }).toList(),
          onChanged: (value) => setState(() => _selectedCity = value),
          validator: (value) => value == null || value.isEmpty ? 'مطلوب' : null,
          decoration: InputDecoration(
            labelText: 'المدينة',
            hintText: 'اختر المدينة',
            prefixIcon: const Icon(Icons.location_city_rounded),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.primaryColor)),
            filled: true,
            fillColor: Colors.white,
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
        spacing,

        CustomTextFormField(
          labelText: 'الموقع',
          hintText: 'حدد الموقع على الخريطة',
          controller: _locationController,
          readOnly: true,
          suffixIcon: const Icon(Icons.location_on_outlined, color: AppTheme.primaryColor),
          onTap: () => _locationController.text = 'حي العوالي، مكة',
        ),
        spacing,

        CustomTextFormField(
          labelText: 'الوصف',
          hintText: 'يُسمح الى 150 كلمه',
          controller: _descriptionController,
          maxLines: 4,
        ),
        spacing,

        const Text('عدد الغرف والمرافق', style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textColor)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: CustomDropdownField<int>(labelText: 'غرف', value: _selectedRooms, items: List.generate(5, (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}'))), onChanged: (val) => setState(() => _selectedRooms = val))),
            const SizedBox(width: 12),
            Expanded(child: CustomDropdownField<int>(labelText: 'دورات مياه', value: _selectedBathrooms, items: List.generate(5, (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}'))), onChanged: (val) => setState(() => _selectedBathrooms = val))),
            const SizedBox(width: 12),
            Expanded(child: CustomDropdownField<int>(labelText: 'مرافق', value: _selectedFacilities, items: List.generate(5, (i) => DropdownMenuItem(value: i, child: Text('$i'))), onChanged: (val) => setState(() => _selectedFacilities = val))),
          ],
        ),
        spacing,

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
        spacing,

        const Text('مدة الاشتراك', style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textColor)),
        const SizedBox(height: 12),
        _buildRadioOption('شهري', 'شهري', _selectedDuration, (val) => setState(() => _selectedDuration = val)),
        _buildRadioOption('ترم', 'ترم', _selectedDuration, (val) => setState(() => _selectedDuration = val)),
        _buildRadioOption('سنة دراسية كاملة', 'سنة دراسية كاملة', _selectedDuration, (val) => setState(() => _selectedDuration = val)),
        
        if (_selectedDuration != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor, 
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                CustomTextFormField(
                  labelText: 'السعر',
                  hintText: 'أدخل السعر',
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset('assets/icons/Saudi_Riyal_Symbol.svg.png', height: 20, width: 20, color: AppTheme.subtitleColor),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildDatePickerField('تاريخ البداية', _startDate, (date) => setState(() => _startDate = date))),
                    const SizedBox(width: 12),
                    Expanded(child: _buildDatePickerField('تاريخ النهاية', _endDate, (date) => setState(() => _endDate = date))),
                  ],
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 32),
      ],
    );
  }
}

// ---------------------------------------------------------
// TRANSPORTATION FORM WIDGET
// ---------------------------------------------------------
class _EditTransportForm extends StatefulWidget {
  const _EditTransportForm();

  @override
  State<_EditTransportForm> createState() => _EditTransportFormState();
}

class _EditTransportFormState extends State<_EditTransportForm> {
  final _originController = TextEditingController(text: 'الشرائع');
  final _destinationController = TextEditingController(text: 'جامعة أم القرى - العابدية');
  final _priceController = TextEditingController(text: '400');
  
  String? _selectedCity = 'مكة المكرمة';
  String? _selectedVehicleType = 'bus'; // bus or car
  String? _selectedSeats = '14';
  
  // Features
  bool _hasAC = true;
  bool _hasWifi = false;

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Widget _buildCheckbox(String title, bool value, ValueChanged<bool?> onChanged) {
    return Theme(
      data: Theme.of(context).copyWith(unselectedWidgetColor: AppTheme.subtitleColor),
      child: CheckboxListTile(
        title: Text(title, style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.w600)),
        value: value,
        activeColor: AppTheme.primaryColor,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(height: 20);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: _selectedCity,
          items: AppConstants.saudiCities.map((city) {
            return DropdownMenuItem(value: city, child: Text(city));
          }).toList(),
          onChanged: (value) => setState(() => _selectedCity = value),
          validator: (value) => value == null ? 'مطلوب' : null,
          decoration: InputDecoration(
            labelText: 'المدينة',
            hintText: 'اختر المدينة',
            prefixIcon: const Icon(Icons.location_city_rounded),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.primaryColor)),
            filled: true,
            fillColor: Colors.white,
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
        spacing,

        CustomTextFormField(
          labelText: 'المسار من',
          hintText: 'حي المسفلة',
          controller: _originController,
          prefixIcon: const Icon(Icons.my_location_rounded, color: AppTheme.primaryColor),
        ),
        spacing,

        CustomTextFormField(
          labelText: 'المسار الى',
          hintText: 'جامعة أم القرى - الشميسي',
          controller: _destinationController,
          prefixIcon: const Icon(Icons.location_on_rounded, color: AppTheme.primaryColor),
        ),
        spacing,

        CustomDropdownField<String>(
          labelText: 'نوع المركبة',
          hintText: 'اختر نوع المركبة',
          value: _selectedVehicleType,
          items: const [
            DropdownMenuItem(value: 'bus', child: Text('باص')),
            DropdownMenuItem(value: 'car', child: Text('سيارة خاصة')),
          ],
          onChanged: (val) => setState(() => _selectedVehicleType = val),
        ),
        spacing,

        CustomDropdownField<String>(
          labelText: 'عدد المقاعد',
          hintText: 'اختر عدد المقاعد',
          value: _selectedSeats,
          items: const [
            DropdownMenuItem(value: '4', child: Text('4 مقاعد')),
            DropdownMenuItem(value: '7', child: Text('7 مقاعد')),
            DropdownMenuItem(value: '14', child: Text('14 مقعد (باص صغير)')),
            DropdownMenuItem(value: '30', child: Text('30 مقعد (باص كبير)')),
          ],
          onChanged: (val) => setState(() => _selectedSeats = val),
        ),
        spacing,

        const Text('المميزات', style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textColor)),
        const SizedBox(height: 8),
        _buildCheckbox('مكيف', _hasAC, (val) => setState(() => _hasAC = val ?? false)),
        _buildCheckbox('إنترنت (Wi-Fi)', _hasWifi, (val) => setState(() => _hasWifi = val ?? false)),
        spacing,

        CustomTextFormField(
          labelText: 'السعر الشهري',
          hintText: 'أدخل السعر',
          controller: _priceController,
          keyboardType: TextInputType.number,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset('assets/icons/Saudi_Riyal_Symbol.svg.png', height: 20, width: 20, color: AppTheme.subtitleColor),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
