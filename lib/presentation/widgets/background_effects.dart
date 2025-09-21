import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

// --- ANA EFEKT WIDGET'I ---
class BackgroundEffects extends StatelessWidget {
  final String? condition;
  const BackgroundEffects({super.key, required this.condition});

  @override
  Widget build(BuildContext context) {
    switch (condition?.toLowerCase()) {
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return const RainEffect();
      case 'thunderstorm':
        return const Stack(children: [RainEffect(numberOfDrops: 350), ThunderEffect()]);
      case 'snow':
        return const SnowEffect();
      case 'mist': case 'fog': case 'haze': case 'smoke':
      return const FogEffect();
      case 'clear':
        return const SunShineEffect();
      case 'clouds': // YENİ: Bulutlu hava için efekt eklendi
        return const CloudEffect();
      default:
        return const SizedBox.shrink();
    }
  }
}

// YENİ: BULUTLU HAVA EFEKTİ
class CloudEffect extends StatelessWidget {
  const CloudEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(20, (index) => const MovingCloud()),
    );
  }
}

class MovingCloud extends StatelessWidget {
  const MovingCloud({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final duration = Duration(seconds: 40 + random.nextInt(60));
    final fromLeft = random.nextBool();
    final top = random.nextDouble() * MediaQuery.of(context).size.height * 0.4;
    final size = 150 + random.nextDouble() * 200;
    final opacity = 0.1 + random.nextDouble() * 0.3;

    return LoopAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, value, child) {
        final left = fromLeft
            ? -size + (value * (MediaQuery.of(context).size.width + size))
            : MediaQuery.of(context).size.width - (value * (MediaQuery.of(context).size.width + size));
        return Positioned(
          top: top,
          left: left,
          child: Icon(
            Icons.cloud,
            color: Colors.white.withOpacity(opacity),
            size: size,
          ),
        );
      },
    );
  }
}


// GÜNCELLENDİ: GÜNEŞLİ HAVA EFEKTİ
class SunShineEffect extends StatelessWidget {
  const SunShineEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(40, (index) => const SunSparkle()),
    );
  }
}

class SunSparkle extends StatelessWidget {
  const SunSparkle({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final duration = Duration(milliseconds: 1500 + random.nextInt(2500));
    final top = random.nextDouble() * MediaQuery.of(context).size.height;
    final left = random.nextDouble() * MediaQuery.of(context).size.width;
    final size = 4.0 + random.nextDouble() * 6.0; // Boyut artırıldı

    return LoopAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, value, child) {
        final opacity = (0.5 - (value - 0.5).abs()) * 2;
        return Positioned(
          top: top,
          left: left,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(opacity * 0.8), // Daha görünür hale getirildi
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(opacity * 0.5),
                  blurRadius: size * 2,
                  spreadRadius: size / 2,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- DİĞER EFEKTLER (Aynı kalıyor) ---
// (Yağmur, Kar, Fırtına ve Sis efektleri aynı kaldığı için kodun geri kalanı aynı)
class RainEffect extends StatelessWidget {
  final int numberOfDrops;
  const RainEffect({super.key, this.numberOfDrops = 200});
  @override
  Widget build(BuildContext context) => Stack(
    children: List.generate(numberOfDrops, (index) => const RainDrop()),
  );
}
class RainDrop extends StatelessWidget {
  const RainDrop({super.key});
  @override
  Widget build(BuildContext context) {
    final random = Random();
    final duration = Duration(milliseconds: 800 + random.nextInt(600));
    final left = random.nextDouble() * MediaQuery.of(context).size.width;
    final height = 40 + random.nextDouble() * 60;
    return LoopAnimationBuilder<double>(
      tween: Tween(begin: -height, end: MediaQuery.of(context).size.height),
      duration: duration,
      builder: (context, value, child) {
        return Positioned(
          left: left,
          top: value,
          child: Container(
            width: 1.5,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }
}
class SnowEffect extends StatelessWidget {
  final int numberOfFlakes;
  const SnowEffect({super.key, this.numberOfFlakes = 150});
  @override
  Widget build(BuildContext context) => Stack(
    children: List.generate(numberOfFlakes, (index) => const SnowFlake()),
  );
}
class SnowFlake extends StatelessWidget {
  const SnowFlake({super.key});
  @override
  Widget build(BuildContext context) {
    final random = Random();
    final duration = Duration(seconds: 5 + random.nextInt(10));
    final left = random.nextDouble() * MediaQuery.of(context).size.width;
    final size = 3 + random.nextDouble() * 5;
    return LoopAnimationBuilder<double>(
      tween: Tween(begin: -size, end: MediaQuery.of(context).size.height),
      duration: duration,
      builder: (context, value, child) {
        return Positioned(
          left: left,
          top: value,
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
class ThunderEffect extends StatefulWidget {
  const ThunderEffect({super.key});
  @override
  State<ThunderEffect> createState() => _ThunderEffectState();
}
class _ThunderEffectState extends State<ThunderEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _random = Random();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _triggerFlash();
  }
  void _triggerFlash() async {
    while (mounted) {
      await Future.delayed(Duration(seconds: 3 + _random.nextInt(7)));
      if (mounted) _controller.forward(from: 0.0);
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: FadeTransition(
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_controller),
        child: Container(color: Colors.white.withOpacity(0.4)),
      ),
    );
  }
}
class FogEffect extends StatelessWidget {
  const FogEffect({super.key});
  @override
  Widget build(BuildContext context) { return const SizedBox.shrink(); }}