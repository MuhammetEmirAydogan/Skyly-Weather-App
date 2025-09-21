import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';

class FavoriteCityChip extends StatelessWidget {
  final String cityName;
  final bool isSelected;
  final VoidCallback onTap;

  const FavoriteCityChip({
    super.key,
    required this.cityName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.4)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Colors.white, width: 1.5)
              : null,
        ),
        child: Text(
          cityName,
          style: AppTextStyles.statLabel.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}