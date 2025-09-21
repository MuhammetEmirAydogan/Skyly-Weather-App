import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/theme/app_text_styles.dart';

class HourlyForecastCard extends StatelessWidget {
  final String time;
  final String? lottieAsset;
  final IconData? staticIcon;
  final String temperature;

  const HourlyForecastCard({
    super.key,
    required this.time,
    this.lottieAsset,
    this.staticIcon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(time, style: AppTextStyles.statLabel),
          if (lottieAsset != null)
            Lottie.asset(lottieAsset!, width: 48, height: 48)
          else if (staticIcon != null)
            Icon(staticIcon, color: Colors.white, size: 32),
          Text('$temperature°', style: AppTextStyles.forecastTemp),
        ],
      ),
    );
  }
}