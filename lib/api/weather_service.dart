// weather_service.dart dosyasının içindeki fonksiyonun güncellenmiş hali

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';

class WeatherService {
  Future<Map<String, dynamic>> getWeatherData(String cityName) async {
    try {
      // DEĞİŞİKLİK BURADA: cityName değişkenini Uri.encodeComponent ile sarmaladık
      final url = Uri.parse(
          '${ApiConstants.baseUrl}?q=${Uri.encodeComponent(cityName)}&appid=${ApiConstants.apiKey}&units=metric&lang=tr');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Veri alınamadı. Hata kodu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Bir hata oluştu: $e');
    }
  }
}