import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:glide/core/shared/helper.dart';
import 'package:glide/core/shared/widgets/widgets.dart';
import 'package:glide/features/auth/view/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widgets/on_boarding_item.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentIndex = 0;

  final List<OnBoardingWidget> _onboardingItems = [
    OnBoardingWidget(
      imagePath: "assets/images/on_boarding_1.png",
      title: "Find your next adventure",
      description: "Search for flights, discover new destinations, and plan your perfect trip.",
    ),
    OnBoardingWidget(
      imagePath: "assets/images/on_boarding_2.png",
      title: "Explore with interactive maps",
      description: "Navigate your destination with detailed maps. Find nearby attractions, restaurants, and points of interest.",
    ),
    OnBoardingWidget(
      imagePath: "assets/images/on_boarding_3.png",
      title: "Personalize your experience",
      description: "Create your profile to save favorites, track bookings, and get recommendations tailored to your preferences.",
    ),
  ];

  void _handleButtonPress() {
    if (_currentIndex < _onboardingItems.length - 1) {
      // Move to next page
      _carouselController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    buildNavigatorPushReplacement(context, screen: LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.65,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              enableInfiniteScroll: false,
              autoPlay: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: _onboardingItems,
          ),

          // Page indicator
          AnimatedSmoothIndicator(
            activeIndex: _currentIndex,
            count: _onboardingItems.length,
            effect: WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              spacing: 16,
              dotColor: Colors.grey.shade300,
              activeDotColor: Theme.of(context).primaryColor,
            ),
          ),

          Spacer(),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: buildMaterialButton(
                    onPressed: _handleButtonPress,
                    label: _currentIndex < _onboardingItems.length - 1
                        ? "Next"
                        : "Finish",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}