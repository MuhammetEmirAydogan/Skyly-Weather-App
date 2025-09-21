import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/theme/app_text_styles.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? lottieAsset; // Hareketli animasyon için dosya yolu
  final IconData? staticIcon; // Hareketsiz ikon (Lottie olmayanlar için)

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.lottieAsset,
    this.staticIcon,
  });

  @override
  Widget build(BuildContext context) {
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
                  Text(label, style: AppTextStyles.statLabel),
                  // Yeni mantık: Eğer lottieAsset varsa Lottie'yi, yoksa staticIcon'u göster
                  if (lottieAsset != null)
                    Lottie.asset(lottieAsset!, width: 40, height: 40)
                  else if (staticIcon != null)
                    Icon(staticIcon, color: Colors.white70, size: 24)
                ],
              ),
              const Spacer(),
              Text(value, style: AppTextStyles.statValue),
            ],
          ),
        ),
      ),
    );
  }
}