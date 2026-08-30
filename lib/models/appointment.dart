class Appointment {
  final String id;
  final String userId;
  final String consultantName;
  final String specialization;
  final DateTime date;
  final String time;
  final String userName;
  final String phone;
  final String reason;
  final double fee;
  final String status;

  const Appointment({
    required this.id,
    required this.userId,
    required this.consultantName,
    required this.specialization,
    required this.date,
    required this.time,
    required this.userName,
    required this.phone,
    required this.reason,
    required this.fee,
    required this.status,
  });

  Appointment copyWith({
    String? id,
    String? userId,
    String? consultantName,
    String? specialization,
    DateTime? date,
    String? time,
    String? userName,
    String? phone,
    String? reason,
    double? fee,
    String? status,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      consultantName:
          consultantName ?? this.consultantName,
      specialization:
          specialization ?? this.specialization,
      date: date ?? this.date,
      time: time ?? this.time,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      reason: reason ?? this.reason,
      fee: fee ?? this.fee,
      status: status ?? this.status,
    );
  }
}