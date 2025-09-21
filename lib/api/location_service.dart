import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<String> getCurrentCity() async {
    // 1. Konum servisleri cihazda açık mı diye kontrol et
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Konum servisleri kapalı.');
    }

    // 2. Uygulama için konum iznini kontrol et
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Konum izni reddedildi.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Konum izni kalıcı olarak reddedildi. Lütfen uygulama ayarlarından izin verin.');
    }

    // 3. İzinler tamamsa, mevcut konumu al
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // 4. Konumu (enlem/boylam) şehir adına çevir
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);

    // 5. Şehir adını bul ve döndür
    String? city = placemarks[0].locality;
    if (city == null || city.isEmpty) {
      return Future.error('Şehir adı bulunamadı.');
    }

    return city;
  }
}