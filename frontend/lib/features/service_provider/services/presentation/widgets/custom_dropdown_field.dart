import 'package:flutter/material.dart';
import 'package:wasl/core/theme/app_theme.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;

  const CustomDropdownField({
    super.key,
    required this.labelText,
    required this.items,
    this.hintText,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value, // keeping value here because initialValue is for form field but this behaves better dynamically for state
          items: items,
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 14,
            color: AppTheme.textColor,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            // Leverages standard input decoration for uniform look
          ),
          // Default mandatory validation
          validator: validator ??
              (val) {
                if (val == null) {
                  return 'يرجى الاختيار'; // "Please select"
                }
                return null;
              },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}
