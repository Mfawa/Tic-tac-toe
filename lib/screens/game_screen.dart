import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../model/game_model.dart';
import '../provider/game_provider.dart';
import '../widgets/widgets.dart';
import 'loading_screen.dart';

Color parchment = Color.fromRGBO(242, 231, 207, 1);

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late Widget activeX;
  late Widget activeO;
  final controller = ConfettiController();
  List<ConfettiController> killableControllerList = [];

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider).game;
    var gameStateDraw = gameState.isDraw;
    var gameStateWin = gameState.winner;
    final gameStateSeries = ref.watch(gameProvider).series;
    final current = gameState.currentPlayer;
    Widget body;
    final gameController = ref.read(gameProvider.notifier);

    if (gameStateDraw == false && gameStateWin == null) {
      if (current == 'X') {
        activeX = Container(
          width: 300,
          height: 150,
          alignment: Alignment.center,
          decoration: redDecoration,
          child: _buildGameInfo(gameState, gameStateSeries),
        ).animate(delay: 10.ms).fadeIn();
        activeO = Container(width: 00, height: 150);
        body = _buildBody();
      } else if (current == 'O') {
        activeX = Container(width: 00, height: 150);
        activeO = Container(
          width: 300,
          height: 150,
          alignment: Alignment.center,
          decoration: blueDecoration,
          child: _buildGameInfo(gameState, gameStateSeries),
        ).animate(delay: 10.ms).fadeIn();
        body = _buildBody();
      } else {
        body = Container();
      }
    }
    //
    else if (gameStateDraw == false && gameStateWin != null) {
      if (gameStateSeries.seriesWinner != null) {
        body = Center(
          child: Container(
            color: gameStateSeries.seriesWinner == 'D' ? parchment : (gameState.winner == 'X' ? Colors.red.shade600 : Colors.blue.shade600),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  gameStateSeries.seriesWinner == 'D'
                      ? 'Series ended in  draw! 😔😔'
                      : (gameStateSeries.seriesWinner == 'X'
                            ? 'Player O wins the series!'
                                  ''
                            : 'Player X wins the series!'
                                  ''),
                  style: TextStyle(fontSize: 30, color: gameStateSeries.seriesWinner == 'D' ? Colors.black : Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
        Timer(Duration(milliseconds: 00), () {
          Confetti.launch(
            context,
            options: ConfettiOptions(
              particleCount: 400,
              spread: 140,
              y: 0.6,
              colors: [gameStateWin == 'X' ? Colors.blue : Colors.red, Colors.white],
            ),
          );
          killableControllerList.add(controller);
        });
        Timer(Duration(seconds: 3), () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NewGame()));
        });
      } else {
        body = Center(
          child: Container(
            color: gameState.winner == 'X' ? Colors.red.shade600 : Colors.blue.shade600,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Player ${gameState.winner} Wins!',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
        Timer(Duration(seconds: 2), () {
          gameController.startNewGame();
        });
      }
    }
    //
    else if (gameStateDraw == true) {
      if (gameStateSeries.draws < 3) {
        if (gameStateSeries.draws == 2 && gameStateSeries.oWins >= 1) {
          body = Center(
            child: Container(
              color: Colors.red,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Player X wins the series!',
                    style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          );
          Timer(Duration(milliseconds: 00), () {
            Confetti.launch(
              context,
              options: ConfettiOptions(
                particleCount: 400,
                spread: 140,
                y: 0.6,
                colors: [gameStateWin == 'X' ? Colors.blue : Colors.red, Colors.white],
              ),
            );
            killableControllerList.add(controller);
          });
          Timer(Duration(seconds: 3), () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NewGame()));
          });
        }
        //
        else if (gameStateSeries.draws == 2 && gameStateSeries.xWins >= 1) {
          body = Center(
            child: Container(
              color: Colors.blue,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Player O wins the series!',
                    style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          );
          Timer(Duration(milliseconds: 00), () {
            Confetti.launch(
              context,
              options: ConfettiOptions(
                particleCount: 400,
                spread: 140,
                y: 0.6,
                colors: [gameStateWin == 'X' ? Colors.blue : Colors.red, Colors.white],
              ),
            );
            killableControllerList.add(controller);
          });
          Timer(Duration(seconds: 3), () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NewGame()));
          });
        }
        //
        else if (gameStateSeries.draws == 1 && gameStateSeries.xWins == 1 && gameStateSeries.oWins == 1) {
          body = Center(
            child: Container(
              color: parchment,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Series ended in  draw! 😔😔', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800))],
              ),
            ),
          );
          Timer(Duration(milliseconds: 00), () {
            Confetti.launch(
              context,
              options: ConfettiOptions(
                particleCount: 400,
                spread: 140,
                y: 0.6,
                colors: [gameStateWin == 'X' ? Colors.blue : Colors.red, Colors.white],
              ),
            );
            killableControllerList.add(controller);
          });
          Timer(Duration(seconds: 3), () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NewGame()));
          });
        }
        //
        //
        else {
          body = Center(
            child: Container(
              color: parchment,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    gameStateSeries.draws > 2
                        ? 'Series ended in a draw!'
                              ''
                        : 'Game Ended in a Draw',
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
          );
          Timer(Duration(seconds: 2), () {
            gameController.startNewGame();
          });
        }
      } else if (gameStateSeries.draws == 3) {
        body = Center(
          child: Container(
            color: parchment,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  gameStateSeries.draws > 2
                      ? 'Series ended in  draw! 😔😔'
                            ''
                      : 'Game Ended in a '
                            'Draw',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
        Timer(Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => NewGame(),
            ),
          );
        });
      }
      //
      else {
        body = _buildBody();
      }
    }
    //
    else {
      body = _buildBody();
    }

    return Scaffold(backgroundColor: parchment, body: body);
  }

  Widget _buildBody() {
    double maxHeight = ScreenSize(context).maxHeight;
    final gameState = ref.watch(gameProvider).game;
    final gameStateSeries = ref.watch(gameProvider).series;
    final gameController = ref.read(gameProvider.notifier);

    return SingleChildScrollView(
      child: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                activeX,
                const SizedBox(height: 10),
                const SizedBox(height: 4),
                Container(
                  height: maxHeight - 310,
                  margin: EdgeInsets.only(left: 30),
                  alignment: Alignment.center,
                  child: _buildBoard(gameState, gameController, gameStateSeries),
                ),
                // _buildActionButtons(gameController, gameStateSeries),
                const SizedBox(height: 10),
                activeO,
              ],
            ),
            Positioned(
              child: Container(
                width: 70,
                height: maxHeight,
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 68,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_buildSeriesInfo(gameStateSeries)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeriesInfo(SeriesState series) {
    final gameState = ref.watch(gameProvider).game;
    return Row(
      children: [
        RotationTransition(
          turns: AlwaysStoppedAnimation(270 / 360),
          child: Text('${series.gamesPlayed}/3', style: const TextStyle(fontSize: 18, color: Colors.white)),
        ),
        const SizedBox(width: 7),
        Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildScoreBadge('X Wins', series.xWins, Colors.blue),
                const SizedBox(height: 0),
                _buildScoreBadge('Draws', series.draws, Colors.grey),
                const SizedBox(height: 0),
                _buildScoreBadge('O Wins', series.oWins, Colors.red),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreBadge(String label, int value, Color color) {
    return RotationTransition(
      turns: AlwaysStoppedAnimation(270 / 360),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(1),
            child: Text(
              '$value',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color),
            ),
          ),
          // const SizedBox(height: 4),
          // Text(
          //   label,
          //   style: TextStyle(
          //     fontSize: 14,
          //     fontWeight: FontWeight.w800,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildGameInfo(GameState game, SeriesState series) {
    if (series.seriesWinner != null) {
      return const SizedBox.shrink();
    }

    if (game.winner != null) {
      return Text(
        'Player ${game.winner} wins this game!',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
      );
    } else if (game.isDraw) {
      return const Text(
        "This game is a draw!",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
      );
    } else {
      return Text("Player ${game.currentPlayer}'s Turn", style: TextStyle(fontSize: 24, color: Colors.white));
    }
  }

  // Widget _buildStatusText(GameState state) {
  //   if (state.winner != null) {
  //     return Text(
  //       'Player ${state.winner} Wins!',
  //       style: const TextStyle(
  //         color: Colors.white,
  //         fontSize: 24,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     );
  //   } else if (state.isDraw) {
  //     return Text(
  //       "It's a Draw!",
  //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //     );
  //   } else {
  //     return Text(
  //       "Player ${state.currentPlayer}'s Turn",
  //       style: const TextStyle(
  //         color: Colors.white,
  //         fontSize: 24,
  //       ),
  //     );
  //   }
  // }

  Widget _buildBoard(GameState state, GameController controller, SeriesState series) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (col) {
            return _buildCell(
              state.board[row][col],
              () => controller.makeMove(row, col),
              isActive: state.winner == null && !state.isDraw && series.seriesWinner == null,
            );
          }),
        );
      }),
    );
  }

  Widget _buildCell(String value, VoidCallback onTap, {required bool isActive}) {
    final current = ref.watch(gameProvider).game.currentPlayer;
    Color borderColor;
    if (current == 'X') {
      borderColor = Colors.red;
    } else {
      borderColor = Colors.blue;
    }
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(border: Border.all(width: 1, color: borderColor)),
        child: Center(
          child: Text(value, style: const TextStyle(fontSize: 45, fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }
}
