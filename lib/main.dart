import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/views/signin_screen.dart';
import 'features/auth/presentation/views/signup_screen.dart';
import 'features/profile/presentation/views/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // your design size

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Auth Demo',
        theme: AppTheme.darkTheme,
        initialRoute: '/signin',
        routes: {
          '/signin': (_) => const SignInScreen(),
          '/signup': (_) => const SignUpScreen(),
          '/home': (_) => const HomeScreen(),
        },
      ),
    );
  }
}
