import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class LottieNoDataAnimation extends StatelessWidget {
  const LottieNoDataAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      "assets/animations/no-notes.json",
      width: double.infinity,
      height: 200,
      fit: BoxFit.contain,
    );
  }
}