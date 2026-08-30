import '../models/consultant.dart';

class MockData {
  static const List<String> categories = [
    'All',
    'Business',
    'Career',
    'Finance',
    'Technology',
  ];

  static const List<Consultant> consultants = [
    Consultant(
      id: 'c001',
      name: 'Aarav Sharma',
      specialization: 'Business Consultant',
      location: 'Pune, Maharashtra',
      description:
          'Experienced business consultant helping startups and businesses with planning, strategy and growth.',
      rating: 4.9,
      experience: 8,
      fee: 800,
      category: 'Business',
      availableDays: [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Friday',
      ],
      availableTimes: [
        '09:00 AM',
        '10:00 AM',
        '11:00 AM',
        '02:00 PM',
        '03:00 PM',
        '04:00 PM',
      ],
    ),
    Consultant(
      id: 'c002',
      name: 'Priya Patel',
      specialization: 'Career Consultant',
      location: 'Mumbai, Maharashtra',
      description:
          'Career consultant helping students and professionals make better career decisions.',
      rating: 4.8,
      experience: 6,
      fee: 600,
      category: 'Career',
      availableDays: [
        'Monday',
        'Thursday',
        'Friday',
        'Saturday',
      ],
      availableTimes: [
        '10:00 AM',
        '11:00 AM',
        '01:00 PM',
        '03:00 PM',
        '04:00 PM',
      ],
    ),
    Consultant(
      id: 'c003',
      name: 'Rahul Mehta',
      specialization: 'Technology Consultant',
      location: 'Nashik, Maharashtra',
      description:
          'Technology consultant helping organizations select suitable technology solutions.',
      rating: 4.7,
      experience: 7,
      fee: 700,
      category: 'Technology',
      availableDays: [
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Saturday',
      ],
      availableTimes: [
        '09:00 AM',
        '11:00 AM',
        '12:00 PM',
        '02:00 PM',
        '04:00 PM',
      ],
    ),
    Consultant(
      id: 'c004',
      name: 'Sneha Joshi',
      specialization: 'Financial Consultant',
      location: 'Ahmednagar, Maharashtra',
      description:
          'Financial consultant providing guidance for budgeting, planning and financial decisions.',
      rating: 4.9,
      experience: 9,
      fee: 900,
      category: 'Finance',
      availableDays: [
        'Monday',
        'Wednesday',
        'Friday',
        'Saturday',
      ],
      availableTimes: [
        '09:00 AM',
        '10:00 AM',
        '12:00 PM',
        '03:00 PM',
        '04:00 PM',
      ],
    ),
  ];
}