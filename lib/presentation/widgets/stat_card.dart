import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    // Buzlu cam efekti için bu yapı kullanılır: ClipRRect -> BackdropFilter -> Container
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.statLabel,
                  ),
                  Icon(
                    icon,
                    color: iconColor ?? Colors.white70,
                    size: 20,
                  ),
                ],
              ),
              const Spacer(), // Boşlukları doldurur
              Text(
                value,
                style: AppTextStyles.statValue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}