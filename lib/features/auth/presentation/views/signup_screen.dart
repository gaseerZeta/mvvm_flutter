import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mvvm_flutter/features/auth/presentation/views/widgets/email_text_field.dart';
import 'package:mvvm_flutter/features/auth/presentation/views/widgets/password_textfield.dart';

import '../viewmodels/auth_viewmodel.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _phoneCtl = TextEditingController();

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
  }

  void _startAnimations() {
    Future.delayed(Duration(milliseconds: 150), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _nameCtl.dispose();
    _emailCtl.dispose();
    _passCtl.dispose();
    _phoneCtl.dispose();
    super.dispose();
  }

  void _onSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    HapticFeedback.lightImpact();

    final vm = ref.read(authViewModelProvider.notifier);
    await vm.signUp(
      name: _nameCtl.text.trim(),
      email: _emailCtl.text.trim(),
      password: _passCtl.text.trim(),
      phone: _phoneCtl.text.trim(),
    );

    final state = ref.read(authViewModelProvider);
    if (state.success) {
      await _showSuccessAnimation();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } else if (state.error != null) {
      _showErrorSnackBar(state.error!);
    }
  }

  Future<void> _showSuccessAnimation() async {
    await _slideController.reverse();
  }

  void _showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  Widget _buildAnimatedField({required Widget child, required int delay}) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 500 + (delay * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.elasticOut,
          builder: (context, value, child) =>
              Transform.scale(scale: value, child: child),
          child: Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,

      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(fontSize: 16.sp),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20.sp),
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
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: theme.colorScheme.onSurface,
            size: 20.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h),

                // Header
                _buildAnimatedField(
                  delay: 0,
                  child: Column(
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_add_rounded,
                          size: 40.sp,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Sign UP',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                          fontSize: 28.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Join us today and get started',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40.h),

                // Form Fields
                _buildAnimatedField(
                  delay: 1,
                  child: _buildCustomTextField(
                    controller: _nameCtl,
                    label: 'Full Name',
                    icon: Icons.person_outline_rounded,
                    keyboardType: TextInputType.name,
                    validator: (s) => (s == null || s.isEmpty)
                        ? 'Enter your full name'
                        : null,
                  ),
                ),

                _buildAnimatedField(
                  delay: 2,
                  child: EmailTextField(controller: _emailCtl),
                ),

                _buildAnimatedField(
                  delay: 3,
                  child: _buildCustomTextField(
                    controller: _phoneCtl,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (s) =>
                        (s == null || s.isEmpty) ? 'Enter phone number' : null,
                  ),
                ),

                _buildAnimatedField(
                  delay: 4,
                  child: PasswordTextField(controller: _passCtl),
                ),

                SizedBox(height: 12.h),

                // Sign Up Button
                _buildAnimatedField(
                  delay: 5,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: state.loading
                        ? Container(
                            height: 56.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: theme.colorScheme.primary.withOpacity(0.1),
                            ),
                            child: Center(
                              child: SizedBox(
                                height: 24.sp,
                                width: 24.sp,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: _onSignUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              elevation: 3,
                              shadowColor: theme.colorScheme.primary
                                  .withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 18.h),
                            ),
                            child: Text(
                              'Sign UP',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Sign In Link
                _buildAnimatedField(
                  delay: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class SignUpScreen extends ConsumerStatefulWidget {
//   const SignUpScreen({super.key});
//   @override
//   ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends ConsumerState<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameCtl = TextEditingController();
//   final _emailCtl = TextEditingController();
//   final _passCtl = TextEditingController();
//   final _phoneCtl = TextEditingController();
//
//   @override
//   void dispose() {
//     _nameCtl.dispose();
//     _emailCtl.dispose();
//     _passCtl.dispose();
//     _phoneCtl.dispose();
//     super.dispose();
//   }
//
//   void _onSignUp() async {
//     if (!_formKey.currentState!.validate()) return;
//     final vm = ref.read(authViewModelProvider.notifier);
//     await vm.signUp(
//       name: _nameCtl.text.trim(),
//       email: _emailCtl.text.trim(),
//       password: _passCtl.text.trim(),
//       phone: _phoneCtl.text.trim(),
//     );
//     final state = ref.read(authViewModelProvider);
//     if (state.success) {
//       Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
//     } else if (state.error != null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(state.error!)));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(authViewModelProvider);
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign Up')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _nameCtl,
//                 decoration: const InputDecoration(labelText: 'Name'),
//                 validator: (s) =>
//                     (s == null || s.isEmpty) ? 'Enter name' : null,
//               ),
//               EmailTextField(controller: _emailCtl),
//               const SizedBox(height: 16),
//               PasswordTextField(controller: _passCtl),
//
//               TextFormField(
//                 controller: _phoneCtl,
//                 decoration: const InputDecoration(labelText: 'Phone'),
//                 validator: (s) =>
//                     (s == null || s.isEmpty) ? 'Enter phone' : null,
//               ),
//               const SizedBox(height: 20),
//               state.loading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: _onSignUp,
//                       child: const Text('Sign Up'),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
