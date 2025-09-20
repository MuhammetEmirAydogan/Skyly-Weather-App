import 'package:flutter/material.dart';
import 'package:skyly/presentation/screens/home_screen.dart'; // Yeni ekranımızı import edeceğiz

void main() {
  runApp(const SkylyApp());
}

class SkylyApp extends StatelessWidget {
  const SkylyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skyly Weather',
      debugShowCheckedModeBanner: false, // Sağ üstteki "Debug" etiketini kaldırır
      theme: ThemeData.dark(), // Şimdilik basit bir karanlık tema kullanıyoruz
      home: const HomeScreen(), // Uygulamanın başlangıç ekranı
    );
  }
}