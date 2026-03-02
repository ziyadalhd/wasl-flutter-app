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
  String? _selectedVehicleType = 'bus'; // 'bus' or 'car'

  // --- Bus Section 1 ---
  final _busModelController = TextEditingController(text: 'تويوتا كوستر');
  final _busYearController = TextEditingController(text: '2020');
  final _busPlateController = TextEditingController(text: 'أ ب ج 1234');
  String? _busSeats = '30'; // 5, 10, ... 50

  // --- Car Section 1 ---
  final _carTypeController = TextEditingController();
  final _carYearController = TextEditingController();
  final _carPlateController = TextEditingController();
  String? _carSeats; // 1 or 2

  // --- Section 2 (Common) ---
  String? _selectedCity = 'مكة المكرمة';
  final _departureLocController = TextEditingController(text: 'حي المسفلة');
  final _universityLocController = TextEditingController(text: 'جامعة أم القرى - العابدية');

  // --- Section 3 Bus (Single) ---
  String? _busSubscriptionDuration = 'semester'; // 'monthly', 'semester', 'yearly'
  final _busPriceController = TextEditingController(text: '1500');
  DateTime? _busStartDate = DateTime.now().add(const Duration(days: 5));
  DateTime? _busEndDate = DateTime.now().add(const Duration(days: 90));

  // --- Section 3 Car (Multiple) ---
  bool _carMonthly = false;
  final _carMonthlyPriceController = TextEditingController();
  DateTime? _carMonthlyStartDate;
  DateTime? _carMonthlyEndDate;

  bool _carSemester = false;
  final _carSemesterPriceController = TextEditingController();
  DateTime? _carSemesterStartDate;
  DateTime? _carSemesterEndDate;

  bool _carYearly = false;
  final _carYearlyPriceController = TextEditingController();
  DateTime? _carYearlyStartDate;
  DateTime? _carYearlyEndDate;

  // --- Section 4 Attachments ---
  bool _hasRegistration = true;
  bool _hasInsurance = true;
  bool _hasVehicleImage = true;

  @override
  void dispose() {
    _busModelController.dispose();
    _busYearController.dispose();
    _busPlateController.dispose();
    _carTypeController.dispose();
    _carYearController.dispose();
    _carPlateController.dispose();
    _departureLocController.dispose();
    _universityLocController.dispose();
    _busPriceController.dispose();
    _carMonthlyPriceController.dispose();
    _carSemesterPriceController.dispose();
    _carYearlyPriceController.dispose();
    super.dispose();
  }

  void _onVehicleTypeChanged(String type) {
    if (_selectedVehicleType != type) {
      setState(() {
        _selectedVehicleType = type;
      });
    }
  }

  // --- Widgets ---

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildVehicleTypeSelector() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'نوع المركبة',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTypeOption(title: '🚌 باص', type: 'bus'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTypeOption(title: '🚗 سيارة', type: 'car'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption({required String title, required String type}) {
    bool isSelected = _selectedVehicleType == type;
    return InkWell(
      onTap: () => _onVehicleTypeChanged(type),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppTheme.textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildBusSection1() {
    return _buildCard(
      title: 'معلومات المركبة - حافلة',
      children: [
        CustomTextFormField(
          labelText: 'نوع المركبة',
          hintText: 'باص',
          readOnly: true,
          validator: (val) => null,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          labelText: 'موديل الباص',
          hintText: 'مثال: تويوتا كوستر',
          controller: _busModelController,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                labelText: 'سنة الصنع',
                hintText: 'مثال: 2020',
                controller: _busYearController,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'مطلوب';
                  final year = int.tryParse(val.trim());
                  if (year == null || val.trim().length != 4) return 'سنة غير صالحة';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextFormField(
                labelText: 'رقم اللوحة',
                hintText: 'مثال: أ ب ج 1234',
                controller: _busPlateController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomDropdownField<String>(
          labelText: 'عدد المقاعد',
          hintText: 'اختر عدد المقاعد',
          value: _busSeats,
          items: [5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
              .map((e) => DropdownMenuItem(value: e.toString(), child: Text(e.toString())))
              .toList(),
          onChanged: (val) => setState(() => _busSeats = val),
          validator: (val) => val == null ? 'الرجاء اختيار عدد المقاعد' : null,
        ),
      ],
    );
  }

  Widget _buildCarSection1() {
    return _buildCard(
      title: 'معلومات المركبة - سيارة',
      children: [
        CustomTextFormField(
          labelText: 'نوع المركبة',
          hintText: 'سيارة',
          readOnly: true,
          validator: (val) => null,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          labelText: 'نوع السيارة',
          hintText: 'مثال: كامري',
          controller: _carTypeController,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                labelText: 'سنة الصنع',
                hintText: 'مثال: 2020',
                controller: _carYearController,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'مطلوب';
                  final year = int.tryParse(val.trim());
                  if (year == null || val.trim().length != 4) return 'سنة غير صالحة';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextFormField(
                labelText: 'رقم اللوحة',
                hintText: 'مثال: أ ب ج 1234',
                controller: _carPlateController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomDropdownField<String>(
          labelText: 'عدد المقاعد',
          hintText: 'اختر عدد المقاعد',
          value: _carSeats,
          items: [1, 2]
              .map((e) => DropdownMenuItem(value: e.toString(), child: Text(e.toString())))
              .toList(),
          onChanged: (val) => setState(() => _carSeats = val),
          validator: (val) => val == null ? 'الرجاء اختيار عدد المقاعد' : null,
        ),
      ],
    );
  }

  Widget _buildSection2Route() {
    return _buildCard(
      title: 'معلومات المسار',
      children: [
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
        CustomTextFormField(
          labelText: 'موقع الانطلاق',
          hintText: 'حدد موقع الانطلاق على الخريطة',
          controller: _departureLocController,
          readOnly: true,
          suffixIcon: const Icon(Icons.location_on_outlined, color: AppTheme.primaryColor),
          onTap: () {
            // Mock Location Picker
            setState(() => _departureLocController.text = 'موقع الانطلاق (تم التحديد)');
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          labelText: 'موقع الجامعة',
          hintText: 'حدد موقع الجامعة على الخريطة',
          controller: _universityLocController,
          readOnly: true,
          suffixIcon: const Icon(Icons.location_on_outlined, color: AppTheme.primaryColor),
          onTap: () {
            // Mock Location Picker
            setState(() => _universityLocController.text = 'موقع الجامعة (تم التحديد)');
          },
        ),
      ],
    );
  }

  Widget _buildBusSection3Duration() {
    return _buildCard(
      title: 'مدة الاشتراك',
      children: [
        const Text(
          'اختر مدة واحدة فقط للاشتراك',
          style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: AppTheme.subtitleColor),
        ),
        const SizedBox(height: 12),
        _buildRadioOption('شهري', 'monthly', _busSubscriptionDuration, (val) => setState(() => _busSubscriptionDuration = val)),
        _buildRadioOption('ترم', 'semester', _busSubscriptionDuration, (val) => setState(() => _busSubscriptionDuration = val)),
        _buildRadioOption('سنة دراسية كاملة', 'yearly', _busSubscriptionDuration, (val) => setState(() => _busSubscriptionDuration = val)),
        
        if (_busSubscriptionDuration != null) ...[
          const SizedBox(height: 16),
          _buildSubscriptionDetailsBlock(
            priceController: _busPriceController,
            startDate: _busStartDate,
            endDate: _busEndDate,
            onStartDatePicked: (date) => setState(() => _busStartDate = date),
            onEndDatePicked: (date) => setState(() => _busEndDate = date),
          ),
        ]
      ],
    );
  }

  Widget _buildCarSection3Duration() {
    return _buildCard(
      title: 'مدة الاشتراك',
      children: [
        const Text(
          'يمكنك اختيار أكثر من مدة للاشتراك',
          style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: AppTheme.subtitleColor),
        ),
        const SizedBox(height: 12),
        
        _buildCheckboxOption('شهري', _carMonthly, (val) => setState(() => _carMonthly = val ?? false)),
        if (_carMonthly)
          _buildSubscriptionDetailsBlock(
            priceController: _carMonthlyPriceController,
            startDate: _carMonthlyStartDate,
            endDate: _carMonthlyEndDate,
            onStartDatePicked: (date) => setState(() => _carMonthlyStartDate = date),
            onEndDatePicked: (date) => setState(() => _carMonthlyEndDate = date),
            padding: const EdgeInsets.only(bottom: 16),
          ),
          
        _buildCheckboxOption('ترم', _carSemester, (val) => setState(() => _carSemester = val ?? false)),
        if (_carSemester)
          _buildSubscriptionDetailsBlock(
            priceController: _carSemesterPriceController,
            startDate: _carSemesterStartDate,
            endDate: _carSemesterEndDate,
            onStartDatePicked: (date) => setState(() => _carSemesterStartDate = date),
            onEndDatePicked: (date) => setState(() => _carSemesterEndDate = date),
            padding: const EdgeInsets.only(bottom: 16),
          ),
          
        _buildCheckboxOption('سنة دراسية كاملة', _carYearly, (val) => setState(() => _carYearly = val ?? false)),
        if (_carYearly)
          _buildSubscriptionDetailsBlock(
            priceController: _carYearlyPriceController,
            startDate: _carYearlyStartDate,
            endDate: _carYearlyEndDate,
            onStartDatePicked: (date) => setState(() => _carYearlyStartDate = date),
            onEndDatePicked: (date) => setState(() => _carYearlyEndDate = date),
          ),
      ],
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

  Widget _buildCheckboxOption(String title, bool value, ValueChanged<bool?> onChanged) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: AppTheme.subtitleColor,
      ),
      child: CheckboxListTile(
        title: Text(title, style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.w600)),
        value: value,
        activeColor: AppTheme.primaryColor,
        contentPadding: EdgeInsets.zero,
        dense: true,
        controlAffinity: ListTileControlAffinity.leading,
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
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
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

  Widget _buildSection4Attachments() {
    return _buildCard(
      title: 'المرفقات',
      children: [
        _buildFileUploadOption(
          title: 'صورة الاستمارة', 
          isUploaded: _hasRegistration, 
          onUpload: () => setState(() => _hasRegistration = true)
        ),
        const SizedBox(height: 16),
        _buildFileUploadOption(
          title: 'صورة التأمين', 
          isUploaded: _hasInsurance, 
          onUpload: () => setState(() => _hasInsurance = true)
        ),
        const SizedBox(height: 16),
        _buildFileUploadOption(
          title: _selectedVehicleType == 'bus' ? 'صورة الباص' : 'صورة السيارة', 
          isUploaded: _hasVehicleImage, 
          onUpload: () => setState(() => _hasVehicleImage = true)
        ),
      ],
    );
  }

  Widget _buildFileUploadOption({required String title, required bool isUploaded, required VoidCallback onUpload}) {
    return InkWell(
      onTap: onUpload,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUploaded ? Colors.green.withOpacity(0.05) : AppTheme.inputFillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUploaded ? Colors.green.withOpacity(0.5) : Colors.grey.withOpacity(0.2),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isUploaded ? Icons.check_circle_rounded : Icons.cloud_upload_outlined,
              color: isUploaded ? Colors.green : AppTheme.primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textColor,
                ),
              ),
            ),
            if (!isUploaded)
              const Text(
                'إرفاق',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              )
            else
              const Text(
                'تم الإرفاق',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVehicleTypeSelector(),
        if (_selectedVehicleType == 'bus') _buildBusSection1(),
        if (_selectedVehicleType == 'car') _buildCarSection1(),
        _buildSection2Route(),
        if (_selectedVehicleType == 'bus') _buildBusSection3Duration(),
        if (_selectedVehicleType == 'car') _buildCarSection3Duration(),
        _buildSection4Attachments(),
      ],
    );
  }
}
