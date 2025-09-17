import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onCountryChanged;

  const PhoneTextField({
    super.key,
    required this.controller,
    this.onCountryChanged,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  String _selectedCountryKey = "IN";

  // Country data with validation rules
  final Map<String, Map<String, dynamic>> _countryData = {
    'IN': {
      'code': '+91',
      'name': 'India',
      'flag': '🇮🇳',
      'length': 10,
      'pattern': r'^[6-9][0-9]{9}$', // Indian mobile numbers start with 6-9
      'example': '9876543210',
    },
    'US': {
      'code': '+1',
      'name': 'USA',
      'flag': '🇺🇸',
      'length': 10,
      'pattern': r'^[2-9][0-9]{2}[2-9][0-9]{6}$', // US format: NXX-NXX-XXXX
      'example': '2125551234',
    },
    'GB': {
      'code': '+44',
      'name': 'UK',
      'flag': '🇬🇧',
      'length': 10,
      'pattern':
          r'^[17][0-9]{9}$|^[2-9][0-9]{8}$', // UK mobile starts with 7, landline varies
      'example': '7700123456',
    },
    'CN': {
      'code': '+86',
      'name': 'China',
      'flag': '🇨🇳',
      'length': 11,
      'pattern': r'^1[3-9][0-9]{9}$', // Chinese mobile starts with 1
      'example': '13812345678',
    },
    'JP': {
      'code': '+81',
      'name': 'Japan',
      'flag': '🇯🇵',
      'length': 10,
      'pattern': r'^[789]0[0-9]{8}$', // Japanese mobile: 70, 80, 90
      'example': '9012345678',
    },
    'DE': {
      'code': '+49',
      'name': 'Germany',
      'flag': '🇩🇪',
      'length': 11,
      'pattern': r'^1[5-7][0-9]{8,9}$', // German mobile: 15x, 16x, 17x
      'example': '15123456789',
    },
    'FR': {
      'code': '+33',
      'name': 'France',
      'flag': '🇫🇷',
      'length': 9,
      'pattern': r'^[67][0-9]{8}$', // French mobile: 6 or 7
      'example': '612345678',
    },
    'AU': {
      'code': '+61',
      'name': 'Australia',
      'flag': '🇦🇺',
      'length': 9,
      'pattern': r'^4[0-9]{8}$', // Australian mobile starts with 4
      'example': '412345678',
    },
    'AE': {
      'code': '+971',
      'name': 'UAE',
      'flag': '🇦🇪',
      'length': 9,
      'pattern': r'^5[0-9]{8}$', // UAE mobile starts with 5
      'example': '501234567',
    },
    'SG': {
      'code': '+65',
      'name': 'Singapore',
      'flag': '🇸🇬',
      'length': 8,
      'pattern': r'^[89][0-9]{7}$', // Singapore mobile: 8 or 9
      'example': '81234567',
    },
    'CA': {
      'code': '+1',
      'name': 'Canada',
      'flag': '🇨🇦',
      'length': 10,
      'pattern': r'^[2-9][0-9]{2}[2-9][0-9]{6}$', // Same as US
      'example': '4165551234',
    },
    'BR': {
      'code': '+55',
      'name': 'Brazil',
      'flag': '🇧🇷',
      'length': 11,
      'pattern': r'^[1-9][1-9][9][0-9]{8}$', // Brazilian mobile format
      'example': '11987654321',
    },
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(12.r),
                color: theme.colorScheme.surface,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Color(0xFF60A5FA),
                  value: _selectedCountryKey,
                  icon: Icon(Icons.keyboard_arrow_down, size: 18.sp),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: theme.colorScheme.onSurface,
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCountryKey = newValue;
                        countryCode = _countryData[newValue]!['code'];
                      });

                      // Clear the text field when country changes
                      widget.controller.clear();

                      // Notify parent widget about country change
                      if (widget.onCountryChanged != null) {
                        widget.onCountryChanged!(countryCode);
                      }
                    }
                  },
                  items: _countryData.entries.map<DropdownMenuItem<String>>((
                    entry,
                  ) {
                    final country = entry.value;
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            country['flag'],
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            country['code'],
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: widget.controller,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: _countryData[_selectedCountryKey]!['example'],
                  prefixIcon: Icon(Icons.phone, size: 20.sp),
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  hintStyle: TextStyle(
                    fontSize: 12.sp,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                    _countryData[_selectedCountryKey]!['length'],
                  ),
                ],
                validator: _validatePhoneNumber,
                onChanged: (value) {
                  if (widget.onCountryChanged != null) {
                    widget.onCountryChanged!('${countryCode}${value.trim()}');
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Text(
            'Format: ${_countryData[_selectedCountryKey]!['code']} ${_countryData[_selectedCountryKey]!['example']}',
            style: TextStyle(
              fontSize: 11.sp,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }

  String? _validatePhoneNumber(String? value) {
    final trimmed = value?.trim() ?? '';
    final countryInfo = _countryData[_selectedCountryKey]!;

    if (trimmed.isEmpty) {
      return 'Phone number is required';
    }

    // Check length
    if (trimmed.length != countryInfo['length']) {
      return 'Phone number must be ${countryInfo['length']} digits for ${countryInfo['name']}';
    }

    // Check pattern
    final pattern = RegExp(countryInfo['pattern']);
    if (!pattern.hasMatch(trimmed)) {
      return 'Invalid ${countryInfo['name']} phone number format';
    }

    return null;
  }

  // Method to get the complete phone number with country code
  String getCompletePhoneNumber() {
    return countryCode + widget.controller.text.trim();
  }

  // Method to get country info
  Map<String, dynamic> getSelectedCountryInfo() {
    return _countryData[_selectedCountryKey]!;
  }

  // Method to validate phone number programmatically
  bool isValidPhoneNumber() {
    return _validatePhoneNumber(widget.controller.text) == null;
  }

  // Method to format phone number for display
  String getFormattedPhoneNumber() {
    final phoneNumber = widget.controller.text.trim();
    if (phoneNumber.isEmpty) return '';

    final countryInfo = _countryData[_selectedCountryKey]!;
    return '${countryInfo['code']} $phoneNumber';
  }
}

String countryCode = "+91";
