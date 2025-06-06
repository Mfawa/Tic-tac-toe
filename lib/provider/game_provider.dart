import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/game_model.dart';

final gameProvider = StateNotifierProvider<GameController, AppState>((ref) {
  return GameController();
});

class GameController extends StateNotifier<AppState> {
  GameController()
    : super(
        AppState(
          game: GameState(board: List.generate(3, (_) => List.filled(3, ''))),
          series: SeriesState(),
        ),
      );

  void makeMove(int row, int col) {
    if (state.game.board[row][col].isNotEmpty || state.game.winner != null || state.game.isDraw || state.series.seriesWinner != null) {
      return;
    }

    // Create a new board
    final newBoard = state.game.board.map((e) => List.of(e)).toList();
    newBoard[row][col] = state.game.currentPlayer;

    // Check game status
    final winner = _checkWinner(newBoard);
    final isDraw = !winner && _checkDraw(newBoard);

    // Update game state
    state = state.copyWith(
      game: state.game.copyWith(
        board: newBoard,
        currentPlayer: state.game.currentPlayer == 'X' ? 'O' : 'X',
        winner: winner ? state.game.currentPlayer : null,
        isDraw: isDraw,
      ),
    );

    // If game ended, update series state
    if (winner || isDraw) {
      _updateSeriesState(winner ? state.game.currentPlayer : null);
    }
  }

  bool _checkWinner(List<List<String>> board) {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (board[i][0].isNotEmpty && board[i][0] == board[i][1] && board[i][0] == board[i][2]) {
        return true;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[0][i].isNotEmpty && board[0][i] == board[1][i] && board[0][i] == board[2][i]) {
        return true;
      }
    }

    // Check diagonals
    if (board[0][0].isNotEmpty && board[0][0] == board[1][1] && board[0][0] == board[2][2]) {
      return true;
    }
    if (board[0][2].isNotEmpty && board[0][2] == board[1][1] && board[0][2] == board[2][0]) {
      return true;
    }

    return false;
  }

  bool _checkDraw(List<List<String>> board) {
    for (var row in board) {
      if (row.any((cell) => cell.isEmpty)) {
        return false;
      }
    }
    return true;
  }

  void _updateSeriesState(String? winner) {
    int newXWins = state.series.xWins;
    int newOWins = state.series.oWins;
    int newDraws = state.series.draws;
    String? seriesWinner;

    if (winner == 'X')
      newXWins++;
    else if (winner == 'O')
      newOWins++;
    else
      newDraws++;

    // Check for series winner
    if (newXWins >= 2) {
      seriesWinner = 'X';
    } else if (newOWins >= 2) {
      seriesWinner = 'O';
    } else if (state.series.gamesPlayed + 1 >= 3 && newXWins > newOWins) {
      seriesWinner = 'X';
    } else if (state.series.gamesPlayed + 1 >= 3 && newOWins > newXWins) {
      seriesWinner = 'O';
    } else if (state.series.gamesPlayed + 1 >= 3) {
      seriesWinner = 'D'; // Draw in series
    }

    state = state.copyWith(
      series: state.series.copyWith(
        gamesPlayed: state.series.gamesPlayed + 1,
        xWins: newXWins,
        oWins: newOWins,
        draws: newDraws,
        seriesWinner: seriesWinner,
      ),
    );
  }

  void startNewGame() {
    // Determine starting player (alternate between games)

    state = state.copyWith(
      game: GameState(board: List.generate(3, (_) => List.filled(3, '')), currentPlayer: state.game.currentPlayer),
    );
  }

  void resetSeries() {
    state = AppState(
      game: GameState(board: List.generate(3, (_) => List.filled(3, ''))),
      series: SeriesState(),
    );
  }
}
