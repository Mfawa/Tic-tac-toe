import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'game_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(),
        ),
      );
    });
    return Scaffold(
      backgroundColor: parchment,
      body: Center(
        child: Container(
          child: Text(
            "TIC-TAC-TOE",
            style: TextStyle(
              color: Colors.black,
              fontSize: 40,
              fontWeight: FontWeight.w900,
            ),
          ),
        ).animate(delay: 1000.milliseconds).scale().rotate(),
      ),
    );
  }
}
