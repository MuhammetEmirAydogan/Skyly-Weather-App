import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';

class DailyForecastTile extends StatelessWidget {
  final String day;
  final IconData icon;
  final String highTemp;
  final String lowTemp;

  const DailyForecastTile({
    super.key,
    required this.day,
    required this.icon,
    required this.highTemp,
    required this.lowTemp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 120,
            child: Text(day, style: AppTextStyles.forecastDay),
          ),
          Icon(icon, color: Colors.white, size: 28),
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