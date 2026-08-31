import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/primary_button.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {
  final PageController pageController = PageController();

  int currentPage = 0;

  final List<_OnboardingData> pages = const [
    _OnboardingData(
      icon: Icons.search_rounded,
      title: 'Find Consultants',
      description:
          'Discover trusted consultants based on your needs and requirements.',
    ),
    _OnboardingData(
      icon: Icons.calendar_month_rounded,
      title: 'Book Easily',
      description:
          'Choose a convenient date and time and book your appointment quickly.',
    ),
    _OnboardingData(
      icon: Icons.check_circle_outline_rounded,
      title: 'Get Expert Guidance',
      description:
          'Connect with consultants and get professional guidance when you need it.',
    ),
  ];

  void nextPage() {
    if (currentPage < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 35),

            const AppLogo(
              size: 70,
              showName: true,
            ),

            const SizedBox(height: 30),

            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = pages[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: AppColors.primary
                                .withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.icon,
                            size: 75,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: 35),

                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          item.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) {
                  final selected =
                      currentPage == index;

                  return AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    height: 8,
                    width: selected ? 25 : 8,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : AppColors.border,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: PrimaryButton(
                text: currentPage == pages.length - 1
                    ? 'Get Started'
                    : 'Next',
                icon: currentPage == pages.length - 1
                    ? Icons.arrow_forward_rounded
                    : Icons.arrow_forward_rounded,
                onPressed: nextPage,
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
  });
}