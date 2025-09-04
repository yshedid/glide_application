import 'package:flutter/material.dart';

import '../../../core/shared/helper.dart';
import '../../on_boarding/view/on_boarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _dotController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _dotScaleAnimation;
  late Animation<double> _dotOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _dotController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _dotScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 3.0,
    ).animate(CurvedAnimation(
      parent: _dotController,
      curve: Curves.elasticInOut,
    ));

    _dotOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _dotController,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    // Start fade animation
    _fadeController.forward();

    // Start scale animation with a slight delay
    await Future.delayed(Duration(milliseconds: 200));
    _scaleController.forward();

    // Start dot pulsing animation
    await Future.delayed(Duration(milliseconds: 500));
    _dotController.repeat(reverse: true);

    // Navigate after total animation time
    await Future.delayed(Duration(milliseconds: 2500));
    if (mounted) {
      buildNavigatorPushReplacement(context, screen: OnBoarding());
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _fadeAnimation,
            _scaleAnimation,
            _dotScaleAnimation,
            _dotOpacityAnimation,
          ]),
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Stack(
                  children: [
                    Image.asset("assets/images/splash.png"),
                    //try Stack with Alignment(center) if it's not responsive
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.153,
                      left: MediaQuery.of(context).size.width * 0.54,
                      child: Transform.scale(
                        scale: _dotScaleAnimation.value,
                        child: Opacity(
                          opacity: _dotOpacityAnimation.value,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}