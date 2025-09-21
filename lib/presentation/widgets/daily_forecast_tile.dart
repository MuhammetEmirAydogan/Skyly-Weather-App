import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/theme/app_text_styles.dart';

class DailyForecastTile extends StatelessWidget {
  final String day;
  final String? lottieAsset;
  final IconData? staticIcon;
  final String highTemp;
  final String lowTemp;

  const DailyForecastTile({
    super.key,
    required this.day,
    this.lottieAsset,
    this.staticIcon,
    required this.highTemp,
    required this.lowTemp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 120,
            child: Text(day, style: AppTextStyles.forecastDay),
          ),
          if (lottieAsset != null)
            Lottie.asset(lottieAsset!, width: 40, height: 40)
          else if (staticIcon != null)
            Icon(staticIcon, color: Colors.white, size: 28),
          const Spacer(),
          Text('$highTemp°', style: AppTextStyles.forecastTemp),
          const SizedBox(width: 20),
          SizedBox(
            width: 40,
            child: Text('$lowTemp°', style: AppTextStyles.statLabel.copyWith(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}