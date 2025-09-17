import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../providers/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _floatingController;
  late AnimationController _profileController;
  late AnimationController _cardController;

  late Animation<double> _backgroundAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<Offset> _profileSlideAnimation;
  late Animation<double> _profileFadeAnimation;
  late Animation<double> _cardScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileViewModelProvider.notifier).loadProfile();
    });
  }

  void _initAnimations() {
    _backgroundController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _floatingController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _profileController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_backgroundController);

    _floatingAnimation = CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    );

    _profileSlideAnimation =
        Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _profileController,
            curve: Curves.easeOutCubic,
          ),
        );

    _profileFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _profileController, curve: Curves.easeIn),
    );

    _cardScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );
  }

  void _startAnimations() {
    Future.delayed(Duration(milliseconds: 300), () {
      _profileController.forward();
    });

    Future.delayed(Duration(milliseconds: 600), () {
      _cardController.forward();
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _floatingController.dispose();
    _profileController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: AnimatedBackgroundPainter(
            animation: _backgroundAnimation.value,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.05),
              Theme.of(context).colorScheme.tertiary.withOpacity(0.08),
            ],
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildFloatingElement({
    required double top,
    required double left,
    required double size,
    required Color color,
    required IconData icon,
    double? delay,
  }) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        final offset =
            math.sin((_floatingAnimation.value * 2 * math.pi) + (delay ?? 0)) *
            10;
        return Positioned(
          top: top + offset,
          left: left,
          child: Opacity(
            opacity: 0.6 + (_floatingAnimation.value * 0.4),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: color.withOpacity(0.7),
                size: size * 0.5,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(profile) {
    final theme = Theme.of(context);

    return SlideTransition(
      position: _profileSlideAnimation,
      child: FadeTransition(
        opacity: _profileFadeAnimation,
        child: ScaleTransition(
          scale: _cardScaleAnimation,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.surface.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(-5, -5),
                ),
              ],
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile Avatar

                // Welcome Text
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  profile.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),

                SizedBox(height: 20.h),

                // Profile Info Cards
                _buildInfoCard(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  value: profile.email,
                  color: theme.colorScheme.primary,
                ),

                SizedBox(height: 12.h),

                _buildInfoCard(
                  icon: Icons.badge_outlined,
                  title: 'Client ID',
                  value: profile.clientId,
                  color: theme.colorScheme.secondary,
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 18.sp, color: color),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.primary.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18.sp, color: theme.colorScheme.primary),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Home',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.logout_rounded,
                color: theme.colorScheme.error,
                size: 20.sp,
              ),
            ),
            onPressed: () async {
              HapticFeedback.mediumImpact();
              await ref.read(authViewModelProvider.notifier).signOut();
              if (mounted) Navigator.pushReplacementNamed(context, '/signin');
            },
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Stack(
        children: [
          // Animated Background
          _buildAnimatedBackground(),

          // Floating Elements
          _buildFloatingElement(
            top: 100.h,
            left: 50.w,
            size: 60.w,
            color: theme.colorScheme.primary,
            icon: Icons.star_outline,
            delay: 0,
          ),
          _buildFloatingElement(
            top: 200.h,
            left: 300.w,
            size: 40.w,
            color: theme.colorScheme.secondary,
            icon: Icons.favorite_outline,
            delay: math.pi / 2,
          ),
          _buildFloatingElement(
            top: 400.h,
            left: 30.w,
            size: 50.w,
            color: theme.colorScheme.tertiary,
            icon: Icons.lightbulb_outline,
            delay: math.pi,
          ),
          _buildFloatingElement(
            top: 500.h,
            left: 320.w,
            size: 35.w,
            color: theme.colorScheme.primary,
            icon: Icons.rocket_launch_outlined,
            delay: 3 * math.pi / 2,
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: state.loading
                  ? Container(
                      padding: EdgeInsets.all(40.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 40.w,
                            height: 40.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Loading your profile...',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : state.profile != null
                  ? SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          _buildProfileCard(state.profile!),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(24.w),
                      margin: EdgeInsets.symmetric(horizontal: 24.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer.withOpacity(
                          0.1,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: theme.colorScheme.error.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48.sp,
                            color: theme.colorScheme.error,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            state.error ?? 'No profile available',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBackgroundPainter extends CustomPainter {
  final double animation;
  final List<Color> colors;

  AnimatedBackgroundPainter({required this.animation, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw animated gradient circles
    for (int i = 0; i < 3; i++) {
      final center = Offset(
        size.width * (0.3 + 0.2 * i) +
            math.cos(animation + i * math.pi / 2) * 50,
        size.height * (0.2 + 0.3 * i) +
            math.sin(animation + i * math.pi / 3) * 30,
      );

      paint.shader =
          RadialGradient(
            colors: [
              colors[i % colors.length].withOpacity(0.3),
              colors[i % colors.length].withOpacity(0.0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: center,
              radius: 100 + math.sin(animation + i) * 20,
            ),
          );

      canvas.drawCircle(center, 100 + math.sin(animation + i) * 20, paint);
    }
  }

  @override
  bool shouldRepaint(AnimatedBackgroundPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
