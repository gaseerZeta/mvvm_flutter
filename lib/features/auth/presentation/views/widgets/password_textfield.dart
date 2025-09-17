import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/validators.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordTextField({super.key, required this.controller});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,

      decoration: InputDecoration(
        labelText: 'Password',
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
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        ),
      ),
      obscureText: _obscure,
      validator: Validators.validatePassword,
    );
  }
}
