import 'package:flutter/material.dart';

class OnBoardingWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnBoardingWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: double.infinity,
          height: (370 / 844) * MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 20),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            description,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
