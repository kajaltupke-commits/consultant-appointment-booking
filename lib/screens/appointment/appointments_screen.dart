import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/appointment.dart';
import '../../services/appointment_service.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() =>
      _AppointmentsScreenState();
}

class _AppointmentsScreenState
    extends State<AppointmentsScreen> {
  Future<void> cancelAppointment(
    Appointment appointment,
  ) async {
    try {
      await AppointmentService.cancelAppointment(
        appointment.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Appointment cancelled successfully.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to cancel appointment: $e',
          ),
        ),
      );
    }
  }

  Future<void> showCancelDialog(
    Appointment appointment,
  ) async {
    final bool? confirm =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Cancel Appointment',
          ),
          content: Text(
            'Are you sure you want to cancel your appointment with ${appointment.consultantName}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await cancelAppointment(appointment);
    }
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppColors.success;

      case 'cancelled':
        return AppColors.error;

      case 'completed':
        return AppColors.primary;

      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Appointments',
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Appointment>>(
        stream: AppointmentService.getAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 60,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Unable to load appointments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final List<Appointment> appointments =
              snapshot.data ?? [];

          if (appointments.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final Appointment appointment =
                    appointments[index];

                return _buildAppointmentCard(
                  appointment,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(
                  alpha: 0.10,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                size: 45,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Appointments',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You do not have any appointments yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(
    Appointment appointment,
  ) {
    final String status = appointment.status;

    final bool canCancel =
        status.toLowerCase() == 'confirmed';

    final Color statusColor =
        getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.04,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color:
                      AppColors.primary.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.consultantName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment.specialization,
                      style: const TextStyle(
                        fontSize: 14,
                        color:
                            AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Divider(
            color: AppColors.border,
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              const Text(
                'Date',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                formatDate(appointment.date),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              const Text(
                'Time',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                appointment.time,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.currency_rupee_rounded,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              const Text(
                'Consultation Fee',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '₹${appointment.fee.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          if (appointment.reason
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.description_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reason',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.w600,
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.reason,
                        style: const TextStyle(
                          color:
                              AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],

          if (canCancel) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  showCancelDialog(
                    appointment,
                  );
                },
                icon: const Icon(
                  Icons.cancel_outlined,
                ),
                label: const Text(
                  'Cancel Appointment',
                ),
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      AppColors.error,
                  side: const BorderSide(
                    color: AppColors.error,
                  ),
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 13,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}