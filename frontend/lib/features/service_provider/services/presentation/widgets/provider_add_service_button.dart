import 'package:flutter/material.dart';

class ProviderAddServiceButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ProviderAddServiceButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: 56, // Standard touch target height
      child: Material(
        color: Colors.grey[100], // Light grey background
        borderRadius: BorderRadius.circular(12), // Slightly rounded corners
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
