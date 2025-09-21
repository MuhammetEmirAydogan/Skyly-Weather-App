import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lottie/lottie.dart';
import 'package:skyly/core/constants/turkey_cities.dart';
import 'package:skyly/api/weather_service.dart';
import 'package:skyly/presentation/widgets/background_effects.dart';
import 'package:skyly/presentation/widgets/daily_forecast_tile.dart';
import 'package:skyly/presentation/widgets/hourly_forecast_card.dart';
import 'package:skyly/presentation/widgets/stat_card.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _weatherData;
  Map<String, dynamic>? _forecastData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather([String cityName = 'Istanbul']) async {
    setState(() {
      _isLoading = true;
      _weatherData = null;
      _forecastData = null;
    });

    try {
      final results = await Future.wait([
        _weatherService.getWeatherData(cityName),
        _weatherService.getForecastData(cityName),
      ]);
      setState(() {
        _weatherData = results[0] as Map<String, dynamic>;
        _forecastData = results[1] as Map<String, dynamic>;
      });
    } catch (e) {
      print('Hata Yakalandı: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${cityName}" şehri bulunamadı.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _getWeatherUIElements(String? mainCondition) {
    IconData staticIcon;
    List<Color> gradient;
    String lottieAsset;

    switch (mainCondition?.toLowerCase()) {
      case 'clouds':
        staticIcon = Icons.cloud;
        gradient = [AppColors.cloudySky_1, AppColors.cloudySky_2];
        lottieAsset = 'assets/lottie/Clouds.json';
        break;
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        staticIcon = Icons.grain;
        gradient = [const Color(0xff525252), const Color(0xff3d72b4)];
        lottieAsset = (mainCondition == 'drizzle')
            ? 'assets/lottie/Weather-partly shower.json'
            : 'assets/lottie/rainy icon.json';
        break;
      case 'thunderstorm':
        staticIcon = Icons.thunderstorm;
        gradient = [const Color(0xff232526), const Color(0xff414345)];
        lottieAsset = 'assets/lottie/Weather-storm.json';
        break;
      case 'snow':
        staticIcon = Icons.ac_unit;
        gradient = [const Color(0xffe6e9f0), const Color(0xffeef1f5)];
        lottieAsset = 'assets/lottie/Weather-snow.json';
        break;
      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
        staticIcon = Icons.foggy;
        gradient = [const Color(0xffbdc3c7), const Color(0xff2c3e50)];
        lottieAsset = 'assets/lottie/Fog Smoke.json';
        break;
      case 'clear':
      default:
        staticIcon = Icons.wb_sunny_rounded;
        gradient = [AppColors.clearSky_1, AppColors.clearSky_2];
        lottieAsset = 'assets/lottie/little sun.json';
        break;
    }
    return {'icon': staticIcon, 'gradient': gradient, 'lottie': lottieAsset};
  }

  Widget _buildBackgroundEffect(String? mainCondition) {
    return BackgroundEffects(condition: mainCondition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.cloudySky_1, AppColors.cloudySky_2],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
      )
          : _buildWeatherUI(),
    );
  }

  Widget _buildWeatherUI() {
    if (_weatherData == null || _forecastData == null) {
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Veri yüklenemedi.', style: TextStyle(color: Colors.white)),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () => _fetchWeather(),
              )
            ],
          ));
    }

    final mainCondition = _weatherData!['weather'][0]['main'];
    final uiElements = _getWeatherUIElements(mainCondition);
    final cityName = _weatherData!['name'];
    final temperature = _weatherData!['main']['temp'].round();
    final condition = toBeginningOfSentenceCase(_weatherData!['weather'][0]['description']);
    final highTemp = _weatherData!['main']['temp_max'].round();
    final lowTemp = _weatherData!['main']['temp_min'].round();
    final windSpeed = (_weatherData!['wind']['speed'] * 3.6).round();
    final humidity = _weatherData!['main']['humidity'];

    final sunriseTimestamp = _weatherData!['sys']['sunrise'];
    final sunsetTimestamp = _weatherData!['sys']['sunset'];
    final sunriseTime = DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000));
    final sunsetTime = DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000));

    final List forecastList = _forecastData!['list'];
    final List hourlyForecasts = forecastList.take(8).toList();
    final Map<String, dynamic> dailyForecasts = {};
    for (var forecast in forecastList) {
      final date = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
      final dayKey = DateFormat('yyyy-MM-dd').format(date);
      if (!dailyForecasts.containsKey(dayKey) && date.hour >= 12) {
        dailyForecasts[dayKey] = forecast;
      }
    }
    final dailyForecastList = dailyForecasts.values.take(5).toList();

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: uiElements['gradient'],
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
            ),
          ),
        ),
        _buildBackgroundEffect(mainCondition),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: [
                // YENİ: LOGO VE ARAMA KUTUSU YAN YANA
                Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 50, // Daha küçük bir boyut
                      height: 50,
                    ),
                    const SizedBox(width: 10), // Logo ile arama kutusu arasında boşluk
                    Expanded( // Arama kutusu kalan alanı kaplar
                      child: TypeAheadField<String>(
                        controller: _searchController,
                        suggestionsCallback: (pattern) {
                          if (pattern.isEmpty) return [];
                          return turkeyCities.where((city) => city.toLowerCase().startsWith(pattern.toLowerCase())).toList();
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(title: Text(suggestion));
                        },
                        onSelected: (suggestion) {
                          _fetchWeather(suggestion);
                          _searchController.clear();
                          FocusScope.of(context).unfocus();
                        },
                        builder: (context, controller, focusNode) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: TextField(
                                controller: controller,
                                focusNode: focusNode,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Şehir ara...',
                                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                                  prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.6)),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  border: InputBorder.none,
                                ),
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    _fetchWeather(value);
                                    _searchController.clear();
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        listBuilder: (context, children) {
                          if (children.isEmpty) return const SizedBox.shrink();
                          return Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            child: ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              children: children.toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // Lottie animasyonunu merkeze almak için kalan kısım
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          uiElements['lottie'],
                          width: 150, height: 150, // Boyutu biraz küçülttük
                        ),
                        const SizedBox(height: 10),
                        Text(cityName, style: AppTextStyles.cityDisplay),
                        const SizedBox(height: 10),
                        Text('$temperature°', style: AppTextStyles.temperatureDisplay),
                        const SizedBox(height: 10),
                        Text(condition ?? '', style: AppTextStyles.conditionDisplay),
                        const SizedBox(height: 10),
                        Text('H: $highTemp°   L: $lowTemp°', style: AppTextStyles.highLowDisplay),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.20, // Belirttiğin gibi %20
          minChildSize: 0.20,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.5,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              StatCard(lottieAsset: 'assets/lottie/Wind Gust.json', label: 'Rüzgar', value: '$windSpeed km/s'),
                              StatCard(lottieAsset: 'assets/lottie/humidity.json', label: 'Nem', value: '%$humidity'),
                              StatCard(lottieAsset: 'assets/lottie/sunrise.json', label: 'Gün Doğumu', value: sunriseTime),
                              StatCard(lottieAsset: 'assets/lottie/sunrise.json', label: 'Gün Batımı', value: sunsetTime),
                              const StatCard(staticIcon: Icons.person_search, label: 'AQI', value: '45'),
                              const StatCard(staticIcon: Icons.wb_sunny_outlined, label: 'UV İndeksi', value: '7'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: hourlyForecasts.length,
                            itemBuilder: (context, index) {
                              final item = hourlyForecasts[index];
                              final time = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
                              final temp = item['main']['temp'].round().toString();
                              final condition = item['weather'][0]['main'];

                              return Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: HourlyForecastCard(
                                  time: DateFormat('HH:mm').format(time),
                                  lottieAsset: _getWeatherUIElements(condition)['lottie'],
                                  temperature: temp,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dailyForecastList.length,
                            itemBuilder: (context, index) {
                              final item = dailyForecastList[index];
                              final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
                              final dayName = DateFormat('EEEE', 'tr_TR').format(date);
                              final highTemp = item['main']['temp_max'].round().toString();
                              final lowTemp = item['main']['temp_min'].round().toString();
                              final condition = item['weather'][0]['main'];

                              return DailyForecastTile(
                                day: dayName,
                                lottieAsset: _getWeatherUIElements(condition)['lottie'],
                                highTemp: highTemp,
                                lowTemp: lowTemp,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}