import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/consultant.dart';

class BookingSuccessScreen extends StatelessWidget {
  final Consultant consultant;
  final DateTime date;
  final String time;

  const BookingSuccessScreen({
    super.key,
    required this.consultant,
    required this.date,
    required this.time,
  });

  String formatDate(DateTime value) {
    return '${value.day}/${value.month}/${value.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Booking Confirmed'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // Success icon
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(
                    alpha: 0.12,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 70,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Appointment Booked!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Your appointment has been successfully confirmed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 30),

              // Appointment details
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Appointment Details',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Consultant
                    Row(
                      children: [
                        _iconBox(
                          Icons.person_rounded,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _detail(
                            'Consultant',
                            consultant.name,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 28),

                    // Specialization
                    Row(
                      children: [
                        _iconBox(
                          Icons.work_outline_rounded,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _detail(
                            'Specialization',
                            consultant.specialization,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 28),

                    // Date
                    Row(
                      children: [
                        _iconBox(
                          Icons.calendar_month_rounded,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _detail(
                            'Date',
                            formatDate(date),
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 28),

                    // Time
                    Row(
                      children: [
                        _iconBox(
                          Icons.access_time_rounded,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _detail(
                            'Time',
                            time,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 28),

                    // Fee
                    Row(
                      children: [
                        _iconBox(
                          Icons.currency_rupee_rounded,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _detail(
                            'Consultation Fee',
                            '₹${consultant.fee.toStringAsFixed(0)}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              PrimaryButton(
                text: 'Back to Home',
                icon: Icons.home_rounded,
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
              ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'View My Appointments',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _iconBox(IconData icon) {
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(
          alpha: 0.10,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: AppColors.primary,
        size: 22,
      ),
    );
  }

  static Widget _detail(
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}