import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/appointment.dart';
import '../../models/consultant.dart';
import '../../services/appointment_service.dart';
import 'booking_success_screen.dart';

class BookingScreen extends StatefulWidget {
  final Consultant consultant;

  const BookingScreen({
    super.key,
    required this.consultant,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? selectedDate;
  String? selectedTime;
  bool isLoading = false;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final reasonController = TextEditingController();

  final List<String> defaultTimes = const [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  Future<void> selectDate() async {
    final today = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: today.add(
        const Duration(days: 60),
      ),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  bool get isFormValid {
    return selectedDate != null &&
        selectedTime != null &&
        nameController.text.trim().isNotEmpty &&
        phoneController.text.trim().isNotEmpty;
  }

  Future<void> confirmBooking() async {
    if (!isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select date, time and enter your details.',
          ),
        ),
      );
      return;
    }

    final User? user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please login before booking an appointment.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final appointment = Appointment(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      userId: user.uid,
      consultantName: widget.consultant.name,
      specialization:
          widget.consultant.specialization,
      date: selectedDate!,
      time: selectedTime!,
      userName: nameController.text.trim(),
      phone: phoneController.text.trim(),
      reason: reasonController.text.trim(),
      fee: widget.consultant.fee,
      status: 'Confirmed',
    );

    try {
      await AppointmentService.addAppointment(
        appointment,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BookingSuccessScreen(
            consultant: widget.consultant,
            date: selectedDate!,
            time: selectedTime!,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to save appointment: $e',
          ),
        ),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<String> get availableTimes {
    try {
      if (widget.consultant.availableTimes.isNotEmpty) {
        return widget.consultant.availableTimes;
      }
    } catch (_) {
      // Use default times.
    }

    return defaultTimes;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
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
                        color: AppColors.primary,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.consultant.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.consultant.specialization,
                            style: const TextStyle(
                              color:
                                  AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Select Date',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              GestureDetector(
                onTap: selectDate,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          selectedDate == null
                              ? 'Choose appointment date'
                              : formatDate(
                                  selectedDate!,
                                ),
                          style: TextStyle(
                            fontSize: 15,
                            color: selectedDate == null
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                            fontWeight:
                                selectedDate == null
                                    ? FontWeight.normal
                                    : FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color:
                            AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Select Time',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    availableTimes.map((time) {
                  final selected =
                      selectedTime == time;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTime = time;
                      });
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary
                            : Colors.white,
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              const Text(
                'Your Details',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: nameController,
                decoration:
                    const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your name',
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: phoneController,
                keyboardType:
                    TextInputType.phone,
                decoration:
                    const InputDecoration(
                  labelText: 'Phone Number',
                  hintText:
                      'Enter your phone number',
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Reason for Appointment',
                  hintText:
                      'Briefly describe your requirement',
                  prefixIcon: Icon(
                    Icons.description_outlined,
                  ),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 25),

              Container(
                padding:
                    const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      AppColors.primary.withValues(
                    alpha: 0.08,
                  ),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.currency_rupee_rounded,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Consultation Fee',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.w600,
                          color:
                              AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '₹${widget.consultant.fee.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              PrimaryButton(
                text: isLoading
                    ? 'Saving Appointment...'
                    : 'Confirm Appointment',
                icon: isLoading
                    ? Icons.hourglass_top_rounded
                    : Icons.check_circle_outline_rounded,
                onPressed:
                    isLoading ? null : confirmBooking,
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}