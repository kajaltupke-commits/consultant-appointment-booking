import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/consultant.dart';
import '../appointment/booking_screen.dart';

class ConsultantDetailsScreen extends StatelessWidget {
  final Consultant consultant;

  const ConsultantDetailsScreen({
    super.key,
    required this.consultant,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultant Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 65,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                consultant.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                consultant.specialization,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    icon: Icons.star_rounded,
                    title: 'Rating',
                    value: consultant.rating.toString(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    icon: Icons.workspace_premium_rounded,
                    title: 'Experience',
                    value:
                        '${consultant.experience} Years',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    icon: Icons.location_on_outlined,
                    title: 'Location',
                    value: consultant.location,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    icon: Icons.currency_rupee_rounded,
                    title: 'Fee',
                    value:
                        '₹${consultant.fee.toStringAsFixed(0)}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Text(
              'About Consultant',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              consultant.description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Available Days',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: consultant.availableDays
                  .map(
                    (day) => Chip(
                      avatar: const Icon(
                        Icons.check_circle_outline,
                        size: 18,
                      ),
                      label: Text(day),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 25),

            const Text(
              'Available Time Slots',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: consultant.availableTimes
                  .map(
                    (time) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(
                          alpha: 0.08,
                        ),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      child: Text(
                        time,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 30),

            PrimaryButton(
              text: 'Book Appointment',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingScreen(
                      consultant: consultant,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 25,
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}