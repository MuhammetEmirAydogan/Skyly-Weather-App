import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart'; // Kendi renk dosyamızı import ediyoruz

// Uygulamamızın metin stillerini tutan sınıf.
class AppTextStyles {
  AppTextStyles._();

  // ANA EKRAN STILLERI
  static final TextStyle temperatureDisplay = GoogleFonts.manrope(
    fontSize: 96,
    fontWeight: FontWeight.w200, // Tasarımdaki "thin" görünüm için
    color: AppColors.textPrimary,
    height: 1, // Yazının alt ve üst boşluğunu azaltır, daha toplu durur
  );

  static final TextStyle cityDisplay = GoogleFonts.manrope(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle conditionDisplay = GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w500, // medium
    color: AppColors.textSecondary,
  );

  static final TextStyle highLowDisplay = GoogleFonts.manrope(
    fontSize: 20,
    fontWeight: FontWeight.w600, // semi-bold
    color: AppColors.textPrimary,
  );


  // DETAY KARTLARI STILLERI (Rüzgar, Nem vb.)
  static final TextStyle statValue = GoogleFonts.manrope(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final TextStyle statLabel = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // TAHMIN LISTESI STILLERI
  static final TextStyle forecastDay = GoogleFonts.manrope(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static final TextStyle forecastTemp = GoogleFonts.manrope(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}