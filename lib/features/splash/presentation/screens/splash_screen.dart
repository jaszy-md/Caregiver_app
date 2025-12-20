import 'package:care_link/app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:care_link/gen/assets.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  late final AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _startPreload());
  }

  Future<void> _startPreload() async {
    final allImages = [...Assets.images.values];

    for (int i = 0; i < allImages.length; i++) {
      await precacheImage(allImages[i].provider(), context);
      if (!mounted) return;

      setState(() {
        _progress = (i + 1) / allImages.length;
      });
    }

    await Future.delayed(const Duration(milliseconds: 150));
    await _fadeController.forward();

    if (!mounted) return;

    // 🔑 DIT IS DE ENIGE JUISTE ACTIE
    AppRouter.markSplashCompleted();

    // 🔁 Router opnieuw laten beslissen
    context.go('/splash');
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004F54),
                  fontFamily: 'Poppins',
                  letterSpacing: 1.0,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'CareLink',
                      speed: const Duration(milliseconds: 150),
                    ),
                  ],
                  totalRepeatCount: 1,
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade300,
                    color: const Color(0xFF004F54),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${(_progress * 100).toInt()}%',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Color(0xFF004F54),
                ),
              ),
            ],
          ),

          // Fade-out overlay
          FadeTransition(
            opacity: _fadeController,
            child: Container(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
