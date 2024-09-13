import 'package:tic_tac_toe_v2/src/model/player.dart';

class GameState {
  final List<List<String>> board;
  final Player? activePlayer;
  final Player? winner;

  GameState({
    required this.board,
    this.activePlayer,
    this.winner,
  });

  GameState copyWith({
    List<List<String>>? board,
    Player? activePlayer,
    Player? winner,
  }) {
    return GameState(
      board: board ?? this.board,
      activePlayer: activePlayer ?? this.activePlayer,
      winner: winner ?? this.winner,
    );
  }

  bool get isBoardFull => board.every((row) => row.every((cell) => cell.isNotEmpty));
}
