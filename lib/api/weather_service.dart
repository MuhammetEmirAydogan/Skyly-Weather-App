import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';

class WeatherService {
  // Bu fonksiyon ANLIK hava durumunu getirir
  Future<Map<String, dynamic>> getWeatherData(String cityName) async {
    final url = Uri.parse(
        '${ApiConstants.baseUrl}?q=${Uri.encodeComponent(cityName)}&appid=${ApiConstants.apiKey}&units=metric&lang=tr');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Anlık veri alınamadı. Hata kodu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Anlık veri hatası: $e');
    }
  }

  // YENİ FONKSİYON: 5 günlük / 3 saatlik TAHMİN verisini getirir
  Future<Map<String, dynamic>> getForecastData(String cityName) async {
    // Adres değiştiğine dikkat et: 'weather' -> 'forecast'
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=${Uri.encodeComponent(cityName)}&appid=${ApiConstants.apiKey}&units=metric&lang=tr');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Tahmin verisi alınamadı. Hata kodu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Tahmin verisi hatası: $e');
    }
  }
}