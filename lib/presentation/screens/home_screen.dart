import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:skyly/core/constants/turkey_cities.dart';
import 'package:skyly/api/weather_service.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _weatherData;
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
    });

    try {
      final data = await _weatherService.getWeatherData(cityName);
      setState(() {
        _weatherData = data;
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

  Map<String, dynamic> _getWeatherUIElements(String? condition) {
    if (condition == null) {
      return {
        'icon': Icons.cloud_off,
        'gradient': [AppColors.cloudySky_1, AppColors.cloudySky_2],
        'iconColor': Colors.grey,
      };
    }

    switch (condition.toLowerCase()) {
      case 'clouds':
        return {
          'icon': Icons.cloud,
          'gradient': [AppColors.cloudySky_1, AppColors.cloudySky_2],
          'iconColor': Colors.white,
        };
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return {
          'icon': Icons.grain,
          'gradient': [const Color(0xff525252), const Color(0xff3d72b4)],
          'iconColor': Colors.blue.shade200,
        };
      case 'thunderstorm':
        return {
          'icon': Icons.thunderstorm,
          'gradient': [const Color(0xff232526), const Color(0xff414345)],
          'iconColor': Colors.yellow,
        };
      case 'snow':
        return {
          'icon': Icons.ac_unit,
          'gradient': [const Color(0xffe6e9f0), const Color(0xffeef1f5)],
          'iconColor': Colors.lightBlue,
        };
      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
        return {
          'icon': Icons.foggy,
          'gradient': [const Color(0xffbdc3c7), const Color(0xff2c3e50)],
          'iconColor': Colors.white54,
        };
      case 'clear':
      default:
        return {
          'icon': Icons.wb_sunny_rounded,
          'gradient': [AppColors.clearSky_1, AppColors.clearSky_2],
          'iconColor': Colors.yellow,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.cloudySky_1, AppColors.cloudySky_2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
      )
          : _buildWeatherUI(),
    );
  }

  Widget _buildWeatherUI() {
    if (_weatherData == null) {
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

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: uiElements['gradient'],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: [
                // V5 İÇİN TAMAMEN YENİDEN YAZILMIŞ YAPI
                TypeAheadField<String>(
                  controller: _searchController,
                  suggestionsCallback: (pattern) {
                    if (pattern.isEmpty) return [];
                    return turkeyCities.where((city) => city.toLowerCase().startsWith(pattern.toLowerCase())).toList();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
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
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(uiElements['icon'], size: 160, color: uiElements['iconColor']),
                        const SizedBox(height: 20),
                        Text(cityName, style: AppTextStyles.cityDisplay),
                        const SizedBox(height: 10),
                        Text('$temperature°', style: AppTextStyles.temperatureDisplay),
                        const SizedBox(height: 10),
                        Text(condition ?? '', style: AppTextStyles.conditionDisplay),
                        const SizedBox(height: 10),
                        Text('H: $highTemp°   L: $lowTemp°', style: AppTextStyles.highLowDisplay),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.35,
          minChildSize: 0.35,
          maxChildSize: 0.8,
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
                              StatCard(icon: Icons.air, label: 'Rüzgar', value: '$windSpeed km/s'),
                              StatCard(icon: Icons.water_drop_outlined, label: 'Nem', value: '%$humidity'),
                              const StatCard(icon: Icons.person_search, label: 'AQI', value: '45'),
                              const StatCard(icon: Icons.wb_sunny_outlined, label: 'UV İndeksi', value: '7'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 140,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            children: const [
                              HourlyForecastCard(time: '19:00', icon: Icons.wb_sunny, temperature: '21'),
                              SizedBox(width: 12),
                              HourlyForecastCard(time: '20:00', icon: Icons.wb_sunny, temperature: '20'),
                              SizedBox(width: 12),
                              HourlyForecastCard(time: '21:00', icon: Icons.wb_sunny, temperature: '19'),
                              SizedBox(width: 12),
                              HourlyForecastCard(time: '22:00', icon: Icons.nightlight_round, temperature: '18'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            children: const [
                              DailyForecastTile(day: 'Çarşamba', icon: Icons.wb_sunny, highTemp: '27', lowTemp: '19'),
                              DailyForecastTile(day: 'Perşembe', icon: Icons.cloud, highTemp: '26', lowTemp: '18'),
                              DailyForecastTile(day: 'Cuma', icon: Icons.grain, highTemp: '25', lowTemp: '17'),
                            ],
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