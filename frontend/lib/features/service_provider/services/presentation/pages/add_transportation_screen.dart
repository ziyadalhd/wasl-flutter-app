import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';
import 'package:wasl/features/service_provider/services/presentation/widgets/custom_text_form_field.dart';
import 'package:wasl/features/service_provider/services/presentation/widgets/custom_dropdown_field.dart';
import 'package:wasl/core/constants/app_constants.dart';

class AddTransportationScreen extends StatefulWidget {
  const AddTransportationScreen({super.key});

  @override
  State<AddTransportationScreen> createState() => _AddTransportationScreenState();
}

class _AddTransportationScreenState extends State<AddTransportationScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedVehicleType; // 'bus' or 'car'

  // --- Bus Section 1 ---
  final _busModelController = TextEditingController();
  final _busYearController = TextEditingController();
  final _busPlateController = TextEditingController();
  String? _busSeats; // 5, 10, ... 50

  // --- Car Section 1 ---
  final _carTypeController = TextEditingController();
  final _carYearController = TextEditingController();
  final _carPlateController = TextEditingController();
  String? _carSeats; // 1 or 2

  // --- Section 2 (Common) ---
  String? _selectedCity;
  final _departureLocController = TextEditingController();
  final _universityLocController = TextEditingController();

  // --- Section 3 Bus (Single) ---
  String? _busSubscriptionDuration; // 'monthly', 'semester', 'yearly'
  final _busPriceController = TextEditingController();
  DateTime? _busStartDate;
  DateTime? _busEndDate;

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
  bool _hasRegistration = false;
  bool _hasInsurance = false;
  bool _hasVehicleImage = false;

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
        
        // Clear all fields when switching type to prevent hidden validation errors or dirty data
        _formKey.currentState?.reset();
        
        _busModelController.clear();
        _busYearController.clear();
        _busPlateController.clear();
        _busSeats = null;
        
        _carTypeController.clear();
        _carYearController.clear();
        _carPlateController.clear();
        _carSeats = null;

        _selectedCity = null;
        _departureLocController.clear();
        _universityLocController.clear();

        _busSubscriptionDuration = null;
        _busPriceController.clear();
        _busStartDate = null;
        _busEndDate = null;

        _carMonthly = false;
        _carMonthlyPriceController.clear();
        _carMonthlyStartDate = null;
        _carMonthlyEndDate = null;

        _carSemester = false;
        _carSemesterPriceController.clear();
        _carSemesterStartDate = null;
        _carSemesterEndDate = null;

        _carYearly = false;
        _carYearlyPriceController.clear();
        _carYearlyStartDate = null;
        _carYearlyEndDate = null;

        _hasRegistration = false;
        _hasInsurance = false;
        _hasVehicleImage = false;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Custom validations
      if (_selectedVehicleType == null) {
        _showErrorSnackBar('الرجاء اختيار نوع المركبة في أعلى الصفحة');
        return;
      }

      if (_selectedVehicleType == 'bus' && _busSubscriptionDuration == null) {
        _showErrorSnackBar('الرجاء اختيار مدة الاشتراك');
        return;
      }

      if (_selectedVehicleType == 'car' && !_carMonthly && !_carSemester && !_carYearly) {
        _showErrorSnackBar('الرجاء اختيار مدة اشتراك واحدة على الأقل');
        return;
      }

      if (!_hasRegistration || !_hasInsurance || !_hasVehicleImage) {
        _showErrorSnackBar('الرجاء ارفاق جميع المستندات المطلوبة');
        return;
      }

      // Add additional date validations if needed (e.g. start date < end date)
      if (_selectedVehicleType == 'bus') {
        if (_busStartDate == null || _busEndDate == null) {
          _showErrorSnackBar('الرجاء تحديد تاريخ البداية والنهاية');
          return;
        }
      }

      if (_selectedVehicleType == 'car') {
        if (_carMonthly && (_carMonthlyStartDate == null || _carMonthlyEndDate == null)) {
          _showErrorSnackBar('الرجاء تحديد التواريخ للاشتراك الشهري');
          return;
        }
        if (_carSemester && (_carSemesterStartDate == null || _carSemesterEndDate == null)) {
          _showErrorSnackBar('الرجاء تحديد التواريخ لاشتراك الترم');
          return;
        }
        if (_carYearly && (_carYearlyStartDate == null || _carYearlyEndDate == null)) {
          _showErrorSnackBar('الرجاء تحديد التواريخ لاشتراك السنة الدراسية');
          return;
        }
      }

      // Success
      _showSuccessDialog();
    } else {
      _showErrorSnackBar('الرجاء تعبئة جميع الحقول المطلوبة بشكل صحيح');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Tajawal')),
        backgroundColor: AppTheme.errorColor,
      ),
    );
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
                'تمت العملية بنجاح\nتم ارسال طلب اضافة النقل الخاص بك',
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
                  Navigator.of(context).pop(); // go back
                },
                child: const Text('حسناً'),
              ),
            ],
          ),
        );
      },
    );
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
            color: Colors.black.withValues(alpha: 0.03),
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
            color: isSelected ? AppTheme.primaryColor : Colors.grey.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
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
          color: isUploaded ? Colors.green.withValues(alpha: 0.05) : AppTheme.inputFillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUploaded ? Colors.green.withValues(alpha: 0.5) : Colors.grey.withValues(alpha: 0.2),
            style: BorderStyle.solid,
            width: isUploaded ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
             Icon(
               isUploaded ? Icons.check_circle_rounded : Icons.cloud_upload_outlined,
               color: isUploaded ? Colors.green : AppTheme.primaryColor,
               size: 32,
             ),
             const SizedBox(width: 16),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                      title,
                      style: const TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textColor),
                   ),
                   const SizedBox(height: 4),
                   Text(
                      isUploaded ? 'تم رفع الملف بنجاح' : 'اضغط لرفع الملف (PNG, JPG, PDF)',
                      style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, color: isUploaded ? Colors.green[700] : AppTheme.subtitleColor),
                   ),
                 ],
               ),
             ),
          ],
        ),
      ),
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
                'نقل جديد', 
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
                        _buildVehicleTypeSelector(),
                        
                        // Dynamic Sections based on selected type
                        if (_selectedVehicleType != null) ...[
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _selectedVehicleType == 'bus' 
                                ? _buildBusSection1() 
                                : _buildCarSection1(),
                          ),
                          _buildSection2Route(),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _selectedVehicleType == 'bus' 
                                ? _buildBusSection3Duration() 
                                : _buildCarSection3Duration(),
                          ),
                          _buildSection4Attachments(),
                          
                          const SizedBox(height: 32),
                        ] else ...[
                          // Placeholder when no vehicle type is selected
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  Icon(Icons.directions_car_filled_outlined, size: 64, color: Colors.grey.withValues(alpha: 0.3)),
                                  const SizedBox(height: 16),
                                  Text(
                                    'الرجاء اختيار نوع المركبة للبدء بتعبئة البيانات',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontSize: 16,
                                      color: AppTheme.subtitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom Submit Button
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
                child: SizedBox(
                   width: double.infinity,
                   height: 50,
                   child: ElevatedButton(
                     onPressed: _submitForm,
                     style: ElevatedButton.styleFrom(
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(12),
                       ),
                       backgroundColor: AppTheme.primaryColor,
                     ),
                     child: const Text(
                       'إرسال النموذج',
                       style: TextStyle(
                         fontFamily: 'Tajawal',
                         fontSize: 16,
                         fontWeight: FontWeight.bold,
                         color: Colors.white,
                       ),
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
}
