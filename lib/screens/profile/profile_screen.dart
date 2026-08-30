import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_logo.dart';
import '../../services/auth_services.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;

  Future<Map<String, dynamic>?> _getProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return null;
    }

    final document = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!document.exists) {
      return null;
    }

    return document.data();
  }

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.logout();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _profileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
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
                  value.isEmpty ? 'Not available' : value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: currentUser == null
          ? _buildNotLoggedIn()
          : FutureBuilder<Map<String, dynamic>?>(
              future: _getProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return _buildError();
                }

                final profile = snapshot.data;

                if (profile == null) {
                  return _buildProfileNotFound();
                }

                final String name =
                    profile['name']?.toString() ?? 'User';

                final String email =
                    profile['email']?.toString() ??
                        currentUser.email ??
                        '';

                final String phone =
                    profile['phone']?.toString() ?? '';

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  color: AppColors.primary,
                  child: SingleChildScrollView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        // Profile icon
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius:
                                BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 55,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          email,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Account information
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Account Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        _profileItem(
                          icon: Icons.person_outline_rounded,
                          title: 'Full Name',
                          value: name,
                        ),

                        _profileItem(
                          icon: Icons.email_outlined,
                          title: 'Email Address',
                          value: email,
                        ),

                        _profileItem(
                          icon: Icons.phone_outlined,
                          title: 'Phone Number',
                          value: phone,
                        ),

                        const SizedBox(height: 15),

                        // Firebase information
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius:
                                BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.verified_user_outlined,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Account Status',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors
                                            .textSecondary,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Firebase account active',
                                      style: TextStyle(
                                        fontWeight:
                                            FontWeight.w600,
                                        color:
                                            AppColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Logout button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed:
                                _isLoading ? null : _logout,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.error,
                                    ),
                                  )
                                : const Icon(
                                    Icons.logout_rounded,
                                  ),
                            label: Text(
                              _isLoading
                                  ? 'Logging out...'
                                  : 'Logout',
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(
                                color: AppColors.error,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        const AppLogo(
                          size: 45,
                          showName: false,
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Consultant Appointment Booking',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildNotLoggedIn() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 70,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'You are not logged in',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 65,
              color: AppColors.error,
            ),
            SizedBox(height: 15),
            Text(
              'Unable to load profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileNotFound() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search_outlined,
              size: 65,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 15),
            Text(
              'Profile not found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your profile information is not available in Firestore.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}