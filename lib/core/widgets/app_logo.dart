import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showName;
  final bool? showText;
  final IconData? icon;

  const AppLogo({
    super.key,
    this.size = 70,
    this.showName = true,
    this.showText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool displayName = showText ?? showName;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon ?? Icons.business_center_rounded,
            color: Colors.white,
            size: size * 0.52,
          ),
        ),

        if (displayName) ...[
          const SizedBox(height: 12),
          const Text(
            AppStrings.appName,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ],
    );
  }
}