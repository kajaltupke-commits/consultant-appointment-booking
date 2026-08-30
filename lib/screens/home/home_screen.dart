import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/consultant_card.dart';
import '../../core/widgets/section_title.dart';
import '../../data/mock_data.dart';
import '../../models/consultant.dart';

import '../appointment/appointments_screen.dart';
import '../consultant/consultant_details_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategory = 0;
  int currentIndex = 0;

  final TextEditingController searchController =
      TextEditingController();

  List<Consultant> get filteredConsultants {
    final query = searchController.text.trim().toLowerCase();

    return MockData.consultants.where((consultant) {
      final categoryMatch = selectedCategory == 0 ||
          consultant.category ==
              MockData.categories[selectedCategory];

      final searchMatch = query.isEmpty ||
          consultant.name.toLowerCase().contains(query) ||
          consultant.specialization.toLowerCase().contains(query) ||
          consultant.category.toLowerCase().contains(query);

      return categoryMatch && searchMatch;
    }).toList();
  }

  void openConsultant(Consultant consultant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConsultantDetailsScreen(
          consultant: consultant,
        ),
      ),
    );
  }

  void openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NotificationsScreen(),
      ),
    );
  }

  void onNavigationTap(int index) {
    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0:
        break;

      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AppointmentsScreen(),
          ),
        );
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const NotificationsScreen(),
          ),
        );
        break;

      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfileScreen(),
          ),
        );
        break;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ---------------- HEADER ----------------
                    Row(
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(
                              alpha: 0.10,
                            ),
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back!',
                                style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Find Your Consultant',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: openNotifications,
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ---------------- BANNER ----------------
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Need Expert Advice?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Connect with trusted consultants and book an appointment easily.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 10),

                          Icon(
                            Icons.support_agent_rounded,
                            color: Colors.white,
                            size: 55,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ---------------- SEARCH ----------------
                    TextField(
                      controller: searchController,
                      onChanged: (_) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText:
                            'Search consultants...',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                        ),
                        suffixIcon:
                            searchController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      searchController.clear();
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.clear_rounded,
                                    ),
                                  )
                                : null,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ---------------- CATEGORIES ----------------
                    const SectionTitle(
                      title: 'Categories',
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      height: 42,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            MockData.categories.length,
                        itemBuilder: (context, index) {
                          final bool selected =
                              selectedCategory == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                right: 10,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primary
                                    : Colors.white,
                                borderRadius:
                                    BorderRadius.circular(25),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(
                                MockData.categories[index],
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
                        },
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ---------------- CONSULTANTS ----------------
                    SectionTitle(
                      title: 'Recommended Consultants',
                      actionText: 'See All',
                      onAction: () {
                        setState(() {
                          selectedCategory = 0;
                          searchController.clear();
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    if (filteredConsultants.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.border,
                          ),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 50,
                              color:
                                  AppColors.textSecondary,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No consultants found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Try another search or category.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...filteredConsultants.map(
                        (consultant) => ConsultantCard(
                          consultant: consultant,
                          onTap: () =>
                              openConsultant(consultant),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ---------------- BOTTOM NAVIGATION ----------------
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onNavigationTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home_rounded,
            ),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.calendar_month_outlined,
            ),
            selectedIcon: Icon(
              Icons.calendar_month_rounded,
            ),
            label: 'Appointments',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.notifications_none_rounded,
            ),
            selectedIcon: Icon(
              Icons.notifications_rounded,
            ),
            label: 'Notifications',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.person_outline_rounded,
            ),
            selectedIcon: Icon(
              Icons.person_rounded,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}