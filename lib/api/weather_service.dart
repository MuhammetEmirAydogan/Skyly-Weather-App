import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart'; // Güvenli anahtar dosyamızı import ediyoruz

class WeatherService {
  // Bu fonksiyon, şehir adına göre hava durumu verisini getirecek
  Future<Map<String, dynamic>> getWeatherData(String cityName) async {
    try {
      // API isteği için tam URL'yi oluşturuyoruz
      // units=metric -> Sıcaklığı Santigrat olarak almak için
      // lang=tr -> Hava durumu açıklamalarını Türkçe almak için
      final url = Uri.parse(
          '${ApiConstants.baseUrl}?q=$cityName&appid=${ApiConstants.apiKey}&units=metric&lang=tr');

      // Belirtilen URL'ye GET isteği gönderiyoruz
      final response = await http.get(url);

      // Eğer sunucudan "200 OK" cevabı dönerse, yani istek başarılıysa
      if (response.statusCode == 200) {
        // Gelen JSON verisini bir Dart Map'ine dönüştürüp geri döndürüyoruz
        return jsonDecode(response.body);
      } else {
        // Sunucudan hata kodu dönerse (örn: 404 - şehir bulunamadı)
        throw Exception('Veri alınamadı. Hata kodu: ${response.statusCode}');
      }
    } catch (e) {
      // İnternet bağlantısı sorunu veya başka bir hata olursa
      throw Exception('Bir hata oluştu: $e');
    }
  }
}