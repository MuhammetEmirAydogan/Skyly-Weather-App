import 'package:flutter/material.dart';
// YENİ İMPORT: Tarih formatlama için gerekli dil verilerini yükler
import 'package:intl/date_symbol_data_local.dart';
import 'package:skyly/presentation/screens/home_screen.dart';

// main fonksiyonunu 'async' olarak güncelliyoruz çünkü içinde 'await' kullanacağız
void main() async {
  // YENİ: runApp'ten önce Flutter'ın başlatıldığından emin olmak için
  WidgetsFlutterBinding.ensureInitialized();
  // YENİ: Türkçe dil verilerini yükle ve yüklenmesini bekle
  await initializeDateFormatting('tr_TR', null);

  runApp(const SkylyApp());
}

class SkylyApp extends StatelessWidget {
  const SkylyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skyly Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}