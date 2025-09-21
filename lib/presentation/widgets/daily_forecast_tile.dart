import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Lottie import'u eklendi
import '../../core/theme/app_text_styles.dart';

class DailyForecastTile extends StatelessWidget {
  final String day;
  final String lottieAsset; // IconData yerine lottieAsset
  final String highTemp;
  final String lowTemp;

  const DailyForecastTile({
    super.key,
    required this.day,
    required this.lottieAsset, // Değişti
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
          // Icon yerine Lottie.asset geldi
          Lottie.asset(lottieAsset, width: 40, height: 40),
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