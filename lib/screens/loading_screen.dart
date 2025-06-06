import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/game_provider.dart';
import 'game_screen.dart';

class NewGame extends ConsumerStatefulWidget {
  const NewGame({super.key});

  @override
  ConsumerState<NewGame> createState() => _NewGameState();
}

class _NewGameState extends ConsumerState<NewGame> {
  @override
  Widget build(BuildContext context) {
    final gameController = ref.read(gameProvider.notifier);
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(),
        ),
      );
      gameController.resetSeries();
    });
    return Scaffold(
      backgroundColor: parchment,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '...loading new game',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
