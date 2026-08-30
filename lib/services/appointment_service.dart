import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/appointment.dart';

class AppointmentService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>>
      get _appointmentsCollection =>
          _firestore.collection('appointments');

  // ============================================================
  // CURRENT USER
  // ============================================================

  static User? get currentUser => _auth.currentUser;

  static String? get currentUserId => _auth.currentUser?.uid;

  // ============================================================
  // ADD APPOINTMENT
  // ============================================================

  static Future<String> addAppointment(
    Appointment appointment,
  ) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'Please login before booking an appointment.',
      );
    }

    final DateTime selectedDate = DateTime(
      appointment.date.year,
      appointment.date.month,
      appointment.date.day,
    );

    final DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (selectedDate.isBefore(today)) {
      throw Exception(
        'You cannot book an appointment in the past.',
      );
    }

    final bool booked = await isSlotBooked(
      consultantName: appointment.consultantName,
      date: appointment.date,
      time: appointment.time,
    );

    if (booked) {
      throw Exception(
        'This time slot is already booked.',
      );
    }

    final DocumentReference<Map<String, dynamic>> document =
        _appointmentsCollection.doc();

    await document.set({
      'id': document.id,
      'userId': user.uid,
      'userName': appointment.userName,
      'phone': appointment.phone,
      'consultantName': appointment.consultantName,
      'specialization': appointment.specialization,
      'date': Timestamp.fromDate(selectedDate),
      'time': appointment.time,
      'reason': appointment.reason,
      'fee': appointment.fee,
      'status': 'Confirmed',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return document.id;
  }

  // ============================================================
  // BOOK APPOINTMENT
  // ============================================================

  static Future<String> bookAppointment({
    required String consultantName,
    required String specialization,
    required DateTime date,
    required String time,
    required String userName,
    required String phone,
    required String reason,
    required double fee,
  }) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'Please login before booking an appointment.',
      );
    }

    final Appointment appointment = Appointment(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      userId: user.uid,
      consultantName: consultantName,
      specialization: specialization,
      date: date,
      time: time,
      userName: userName,
      phone: phone,
      reason: reason,
      fee: fee,
      status: 'Confirmed',
    );

    return addAppointment(appointment);
  }

  // ============================================================
  // CHECK SLOT
  // No composite Firestore index required.
  // ============================================================

  static Future<bool> isSlotBooked({
    required String consultantName,
    required DateTime date,
    required String time,
  }) async {
    final DateTime selectedDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _appointmentsCollection
            .where(
              'consultantName',
              isEqualTo: consultantName,
            )
            .get();

    for (final document in snapshot.docs) {
      final data = document.data();

      final dynamic dateValue = data['date'];

      if (dateValue is! Timestamp) {
        continue;
      }

      final DateTime savedDate = dateValue.toDate();

      final DateTime savedDay = DateTime(
        savedDate.year,
        savedDate.month,
        savedDate.day,
      );

      final String savedTime =
          data['time']?.toString() ?? '';

      final String status =
          data['status']?.toString() ?? '';

      if (status == 'Cancelled') {
        continue;
      }

      if (savedDay == selectedDate &&
          savedTime == time) {
        return true;
      }
    }

    return false;
  }

  // ============================================================
  // GET APPOINTMENTS
  // ============================================================

  static Stream<List<Appointment>> getAppointments() {
    final User? user = _auth.currentUser;

    if (user == null) {
      return Stream.value([]);
    }

    return _appointmentsCollection
        .where(
          'userId',
          isEqualTo: user.uid,
        )
        .snapshots()
        .map((snapshot) {
      final List<Appointment> appointments = [];

      for (final document in snapshot.docs) {
        final data = document.data();

        final dynamic dateValue = data['date'];

        if (dateValue is! Timestamp) {
          continue;
        }

        appointments.add(
          Appointment(
            id: data['id']?.toString() ?? document.id,
            userId: data['userId']?.toString() ?? '',
            consultantName:
                data['consultantName']?.toString() ?? '',
            specialization:
                data['specialization']?.toString() ?? '',
            date: dateValue.toDate(),
            time: data['time']?.toString() ?? '',
            userName:
                data['userName']?.toString() ?? '',
            phone:
                data['phone']?.toString() ?? '',
            reason:
                data['reason']?.toString() ?? '',
            fee: _toDouble(data['fee']),
            status:
                data['status']?.toString() ?? 'Confirmed',
          ),
        );
      }

      appointments.sort(
        (a, b) => a.date.compareTo(b.date),
      );

      return appointments;
    });
  }

  // ============================================================
  // GET USER APPOINTMENTS
  // ============================================================

  static Stream<List<Appointment>> getUserAppointments() {
    return getAppointments();
  }

  // ============================================================
  // GET SINGLE APPOINTMENT
  // ============================================================

  static Future<Appointment?> getAppointment(
    String appointmentId,
  ) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    final DocumentSnapshot<Map<String, dynamic>> document =
        await _appointmentsCollection
            .doc(appointmentId)
            .get();

    if (!document.exists) {
      return null;
    }

    final data = document.data();

    if (data == null) {
      return null;
    }

    if (data['userId'] != user.uid) {
      return null;
    }

    final dynamic dateValue = data['date'];

    if (dateValue is! Timestamp) {
      return null;
    }

    return Appointment(
      id: data['id']?.toString() ?? document.id,
      userId: data['userId']?.toString() ?? '',
      consultantName:
          data['consultantName']?.toString() ?? '',
      specialization:
          data['specialization']?.toString() ?? '',
      date: dateValue.toDate(),
      time: data['time']?.toString() ?? '',
      userName:
          data['userName']?.toString() ?? '',
      phone:
          data['phone']?.toString() ?? '',
      reason:
          data['reason']?.toString() ?? '',
      fee: _toDouble(data['fee']),
      status:
          data['status']?.toString() ?? 'Confirmed',
    );
  }

  // ============================================================
  // CANCEL APPOINTMENT
  // ============================================================

  static Future<void> cancelAppointment(
    String appointmentId,
  ) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'Please login first.',
      );
    }

    final DocumentReference<Map<String, dynamic>> document =
        _appointmentsCollection.doc(appointmentId);

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await document.get();

    if (!snapshot.exists) {
      throw Exception(
        'Appointment not found.',
      );
    }

    final data = snapshot.data();

    if (data == null) {
      throw Exception(
        'Appointment data not found.',
      );
    }

    if (data['userId'] != user.uid) {
      throw Exception(
        'You cannot cancel this appointment.',
      );
    }

    final String status =
        data['status']?.toString() ?? '';

    if (status == 'Cancelled') {
      throw Exception(
        'This appointment is already cancelled.',
      );
    }

    if (status == 'Completed') {
      throw Exception(
        'A completed appointment cannot be cancelled.',
      );
    }

    await document.update({
      'status': 'Cancelled',
      'cancelledAt': FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // COMPLETE APPOINTMENT
  // ============================================================

  static Future<void> completeAppointment(
    String appointmentId,
  ) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'Please login first.',
      );
    }

    final DocumentReference<Map<String, dynamic>> document =
        _appointmentsCollection.doc(appointmentId);

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await document.get();

    if (!snapshot.exists) {
      throw Exception(
        'Appointment not found.',
      );
    }

    final data = snapshot.data();

    if (data == null) {
      throw Exception(
        'Appointment data not found.',
      );
    }

    if (data['userId'] != user.uid) {
      throw Exception(
        'You cannot update this appointment.',
      );
    }

    await document.update({
      'status': 'Completed',
      'completedAt': FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // UPCOMING APPOINTMENTS
  // ============================================================

  static Stream<List<Appointment>>
      getUpcomingAppointments() {
    return getAppointments().map((appointments) {
      final DateTime now = DateTime.now();

      final DateTime today = DateTime(
        now.year,
        now.month,
        now.day,
      );

      return appointments.where((appointment) {
        return appointment.status == 'Confirmed' &&
            !appointment.date.isBefore(today);
      }).toList();
    });
  }

  // ============================================================
  // COMPLETED APPOINTMENTS
  // ============================================================

  static Stream<List<Appointment>>
      getCompletedAppointments() {
    return getAppointments().map((appointments) {
      return appointments.where((appointment) {
        return appointment.status == 'Completed';
      }).toList();
    });
  }

  // ============================================================
  // CANCELLED APPOINTMENTS
  // ============================================================

  static Stream<List<Appointment>>
      getCancelledAppointments() {
    return getAppointments().map((appointments) {
      return appointments.where((appointment) {
        return appointment.status == 'Cancelled';
      }).toList();
    });
  }

  // ============================================================
  // CONVERT FIRESTORE NUMBER TO DOUBLE
  // ============================================================

  static double _toDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    }

    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0.0;
  }

  // ============================================================
  // PARSE TIME
  // ============================================================

  static TimeOfDay? parseTime(String time) {
    try {
      final List<String> parts =
          time.trim().split(' ');

      if (parts.length != 2) {
        return null;
      }

      final List<String> numbers =
          parts[0].split(':');

      if (numbers.length != 2) {
        return null;
      }

      int hour = int.parse(numbers[0]);

      final int minute =
          int.parse(numbers[1]);

      final String period =
          parts[1].toUpperCase();

      if (period == 'PM' && hour != 12) {
        hour += 12;
      }

      if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      if (hour < 0 ||
          hour > 23 ||
          minute < 0 ||
          minute > 59) {
        return null;
      }

      return TimeOfDay(
        hour: hour,
        minute: minute,
      );
    } catch (_) {
      return null;
    }
  }
}