// Game state model
class GameState {
  final List<List<String>> board;
  final String currentPlayer;
  final String? winner;
  final bool isDraw;

  GameState({required this.board, this.currentPlayer = 'X', this.winner, this.isDraw = false});

  GameState copyWith({List<List<String>>? board, String? currentPlayer, String? winner, bool? isDraw}) {
    return GameState(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      winner: winner ?? this.winner,
      isDraw: isDraw ?? this.isDraw,
    );
  }
}

class SeriesState {
  final int gamesPlayed;
  final int xWins;
  final int oWins;
  final int draws;
  final String? seriesWinner;

  SeriesState({this.gamesPlayed = 0, this.xWins = 0, this.oWins = 0, this.draws = 0, this.seriesWinner});

  SeriesState copyWith({int? gamesPlayed, int? xWins, int? oWins, int? draws, String? seriesWinner}) {
    return SeriesState(
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      xWins: xWins ?? this.xWins,
      oWins: oWins ?? this.oWins,
      draws: draws ?? this.draws,
      seriesWinner: seriesWinner ?? this.seriesWinner,
    );
  }
}

class AppState {
  final GameState game;
  final SeriesState series;

  AppState({required this.game, required this.series});

  AppState copyWith({GameState? game, SeriesState? series}) {
    return AppState(game: game ?? this.game, series: series ?? this.series);
  }
}
