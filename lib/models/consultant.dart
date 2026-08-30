class Consultant {
  final String id;
  final String name;
  final String specialization;
  final String location;
  final String description;
  final double rating;
  final int experience;
  final double fee;
  final String category;
  final List<String> availableDays;
  final List<String> availableTimes;

  const Consultant({
    required this.id,
    required this.name,
    required this.specialization,
    required this.location,
    required this.description,
    required this.rating,
    required this.experience,
    required this.fee,
    required this.category,
    required this.availableDays,
    required this.availableTimes,
  });
}