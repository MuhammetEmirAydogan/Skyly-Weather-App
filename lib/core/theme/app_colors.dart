import 'package:flutter/material.dart';

// Uygulamamızın renk paletini tutan sınıf.
class AppColors {
  // Bu sınıfın bir nesnesinin oluşturulmasını engelliyoruz.
  AppColors._();

  // === TASARIM SİSTEMİNDEN GELEN ANA RENKLER ===
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Colors.white70; // rgba(255, 255, 255, 0.7)
  static const Color accent = Color(0xFF38BDF8); // sky-400
  static const Color success = Color(0xFF4ADE80); // green-400 (AQI - Good)
  static const Color warning = Color(0xFFFACC15); // yellow-400 (AQI - Moderate)


  // === TASARIM GÖRSELLERİNDEN ALINAN RENKLER ===
  static const Color panelBackground = Color.fromRGBO(0, 0, 0, 0.2);

  // Dinamik Arka Plan Renkleri (Örnek)
  static const Color clearSky_1 = Color(0xFF67E3FF);
  static const Color clearSky_2 = Color(0xFF53A6FF);

  static const Color cloudySky_1 = Color(0xFF8D99AE);
  static const Color cloudySky_2 = Color(0xFF465362);

}