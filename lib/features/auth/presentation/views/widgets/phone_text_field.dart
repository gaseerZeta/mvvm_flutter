import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneTextField extends StatefulWidget {
  final TextEditingController controller;

  const PhoneTextField({super.key, required this.controller});

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  String _countryCode = "+91"; // default India

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CountryCodePicker(
          onChanged: (code) {
            setState(() {
              _countryCode = code.dialCode ?? "+91";
            });
          },
          initialSelection: 'IN',
          favorite: const ['+91', 'IN', '+1', 'US'],
          showFlag: true,
          showDropDownButton: true,
        ),
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.lock, size: 20.sp),
              labelStyle: TextStyle(
                fontSize: 14.sp,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: theme.colorScheme.error),
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              final trimmed = value?.trim() ?? '';
              if (trimmed.isEmpty) return 'Phone number is required';
              if (trimmed.length < 6 || trimmed.length > 15)
                return 'Enter a valid phone number';
              return null;
            },
          ),
        ),
      ],
    );
  }
}
