# Skyly ☁️ | Dinamik Hava Durumu Uygulaması

![Skyly Logo](assets/images/logo.png) Türkiye'nin şehirleri için tasarlanmış, anlık ve 5 günlük detaylı hava durumu tahminleri sunan, modern ve görsel açıdan zengin bir Flutter uygulaması. Konum tabanlı hava durumu verileri, dinamik animasyonlar ve sezgisel kullanıcı arayüzü ile hava durumu takibini keyifli hale getiriyor.

## ✨ Özellikler

* **Konum Tabanlı Hava Durumu:** Cihazınızın mevcut konumuna göre otomatik olarak hava durumunu getirir.
* **Şehir Arama & Favoriler:** Türkiye'deki tüm şehirleri arayabilir, favori şehirlerinizi hızlıca erişilebilir çip olarak ekleyebilirsiniz.
* **Detaylı Anlık Veriler:** Sıcaklık, hissedilen sıcaklık, rüzgar hızı, nem, gün doğumu/batımı, UV indeksi ve hava kalitesi indeksi (AQI) gibi birçok detaya ulaşın.
* **Saatlik & Günlük Tahminler:** Önümüzdeki 8 saat ve 5 gün için detaylı hava durumu tahminlerini grafiksel olarak inceleyin.
* **Dinamik UI:** Hava durumuna (güneşli, bulutlu, yağmurlu, karlı vb.) ve günün saatine (gündüz/gece) göre arka plan renkleri ve animasyonlar gerçek zamanlı olarak değişir.
* **Modern Tasarım:** Şeffaflık efektleri, akıcı animasyonlar ve temiz tipografi ile minimalist ve kullanıcı dostu bir arayüz.
* **Ücretsiz Lottie Animasyonları:** Performans dostu Lottie animasyonları ile görsel zenginlik sağlanır.

## 🚀 Başlarken

Bu projeyi yerel makinenizde çalıştırmak için aşağıdaki adımları izleyin:

### Ön Gereksinimler

* [Flutter SDK](https://flutter.dev/docs/get-started/install) yüklü olmalı.
* Bir kod düzenleyici (örn. [VS Code](https://code.visualstudio.com/)) ve Flutter eklentileri kurulu olmalı.
* [OpenWeatherMap API Key](https://openweathermap.org/api) edinilmiş olmalı.

### Kurulum

1.  Projeyi klonlayın:
    ```bash
    git clone [https://github.com/KULLANICI_ADIN/Skyly.git](https://github.com/KULLANICI_ADIN/Skyly.git) # Kendi GitHub kullanıcı adınla değiştir
    cd Skyly
    ```
2.  Bağımlılıkları yükleyin:
    ```bash
    flutter pub get
    ```
3.  `.env` dosyasını oluşturun:
    Projenin ana dizininde `.env` adında bir dosya oluşturun ve OpenWeatherMap API anahtarınızı aşağıdaki gibi ekleyin:
    ```
    OPEN_WEATHER_API_KEY=SİZİN_API_ANAHTARINIZ
    ```
4.  Uygulama ikonlarını oluşturun (eğer değiştirmediyseniz):
    ```bash
    flutter pub run flutter_launcher_icons:main
    ```
5.  Uygulamayı çalıştırın:
    ```bash
    flutter run
    ```

## 🛠️ Teknolojiler

* **Flutter:** Mobil uygulama geliştirme framework'ü.
* **Dio:** HTTP istekleri için güçlü bir istemci.
* **Geolocator:** Cihaz konum bilgilerine erişim.
* **Flutter TypeAhead:** Otomatik tamamlama için widget.
* **Lottie:** Gerçek zamanlı animasyonlar için.
* **Flutter Launcher Icons:** Uygulama ikonlarını yönetmek için.
* **Flutter Dotenv:** Ortam değişkenlerini yönetmek için.
* **OpenWeatherMap API:** Hava durumu verileri için.

## 🔮 Gelecek Geliştirmeler (Roadmap)

Skyly uygulamasını daha da geliştirmek için planlanan bazı özellikler:

* **Küresel Şehir Desteği:** Şu anda yalnızca Türkiye şehirleri destekleniyor. Yakın gelecekte dünya genelindeki tüm şehirler için hava durumu desteği eklenecektir.
* **Bildirim Sistemi:** Belirli hava durumu değişiklikleri veya önemli olaylar için kullanıcıları bilgilendiren bildirimler.
* **Tema Seçenekleri:** Açık/koyu tema ve özelleştirilebilir renk paletleri.
* **Çoklu Dil Desteği:** Farklı dillerde kullanım imkanı sunulacak.
* **Widget Desteği:** Ana ekrana eklenebilir hava durumu widget'ları.
* **Harita Entegrasyonu:** Hava durumunu harita üzerinde görselleştirme.
* **Performans Optimizasyonları:** Daha akıcı bir kullanıcı deneyimi için sürekli performans iyileştirmeleri.

## 🤝 Katkıda Bulunma

Geliştirmeye katkıda bulunmak ister misiniz? Lütfen bir pull request (PR) göndermekten veya bir issue (sorun) açmaktan çekinmeyin. Her türlü katkı memnuniyetle karşılanır\!

## 📄 Lisans

Bu proje MIT Lisansı altında lisanslanmıştır. Daha fazla bilgi için [LICENSE](LICENSE) dosyasına bakın.

---

**Muhammet Emir Aydoğan** - 2025