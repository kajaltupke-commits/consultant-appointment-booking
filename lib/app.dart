import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

class AppointmentBookingApp extends StatelessWidget {
  const AppointmentBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Appointment Booking',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
