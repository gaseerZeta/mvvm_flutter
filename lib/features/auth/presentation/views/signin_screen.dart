import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mvvm_flutter/features/auth/presentation/views/widgets/email_text_field.dart';
import 'package:mvvm_flutter/features/auth/presentation/views/widgets/password_textfield.dart';

import '../viewmodels/auth_viewmodel.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();

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
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  void _onSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.lightImpact();

    final vm = ref.read(authViewModelProvider.notifier);
    await vm.signIn(
      email: _emailCtl.text.trim(),
      password: _passCtl.text.trim(),
    );

    final state = ref.read(authViewModelProvider);
    if (state.success) {
      // Add success animation before navigation
      await _showSuccessAnimation();
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildAnimatedContainer({required Widget child, required int delay}) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (delay * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.elasticOut,
          builder: (context, value, child) =>
              Transform.scale(scale: value, child: child),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w), // ScreenUtil
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAnimatedContainer(
                  delay: 0,
                  child: Column(
                    children: [
                      Icon(
                        Icons.login_rounded,
                        size: 64.sp, // ScreenUtil
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Welcome Back',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                          fontSize: 28.sp, // optional adaptive size
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Sign in to continue',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 48.h),

                _buildAnimatedContainer(
                  delay: 1,
                  child: EmailTextField(controller: _emailCtl),
                ),

                SizedBox(height: 16.h),

                _buildAnimatedContainer(
                  delay: 2,
                  child: PasswordTextField(controller: _passCtl),
                ),

                SizedBox(height: 32.h),

                _buildAnimatedContainer(
                  delay: 3,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: state.loading
                        ? Container(
                            height: 48.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: theme.colorScheme.primary.withOpacity(0.1),
                            ),
                            child: Center(
                              child: SizedBox(
                                height: 24.sp,
                                width: 24.sp,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: _onSignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                            ),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 16.h),

                _buildAnimatedContainer(
                  delay: 4,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                    ),
                    child: Text(
                      'Create account',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
