import 'dart:math';

import 'package:riverpod/riverpod.dart';
import 'package:tic_tac_toe_v2/src/data/model/history_model.dart';
import 'package:tic_tac_toe_v2/src/data/local/history_box.dart';
import 'package:tic_tac_toe_v2/src/model/game.dart';
import 'package:tic_tac_toe_v2/src/model/player.dart';

final gameViewModelProvider =
    StateNotifierProvider<GameViewModel, GameState>((ref) {
  final player1 = ref.read(player1Provider);
  final player2 = ref.read(player2Provider);
  final botPlayer = ref.read(botPlayerProvider);
  return GameViewModel(player1, player2, botPlayer);
});

final player1Provider = Provider<Player>((ref) {
  return const Player("Joueur 1", "X");
});

final player2Provider = Provider<Player>((ref) {
  return const Player("Joueur 2", "O");
});

final botPlayerProvider = Provider<Player>((ref) {
  return const Player("Bot", "O");
});

final boardProvider =
    AutoDisposeProvider((ref) => ref.watch(gameViewModelProvider).board);
final activePlayerProvider =
    AutoDisposeProvider((ref) => ref.watch(gameViewModelProvider).activePlayer);
final winnerProvider =
    AutoDisposeProvider((ref) => ref.watch(gameViewModelProvider).winner);

class GameViewModel extends StateNotifier<GameState> {
  final Player player1;
  final Player player2;
  final Player botPlayer;

  GameViewModel(this.player1, this.player2, this.botPlayer)
      : super(GameState(
          board: List.generate(3, (_) => List.filled(3, "")),
          activePlayer: null,
          winner: null,
        ));

  void updateBoard(int row, int col, {bool isBotMove = false}) {
    state.board[row][col] = state.activePlayer!.symbol;
  }

  void botMove() {
    List<List<int>> emptyCells = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (state.board[i][j].isEmpty) {
          emptyCells.add([i, j]);
        }
      }
    }
    // Choisir une case vide aléatoirement
    final random = Random();
    List<int> move = emptyCells[random.nextInt(emptyCells.length)];
    updateBoard(move[0], move[1], isBotMove: true);
    setActivePlayer(player1);
  }

  bool hasWon() {
    // check rows
    for (int row = 0; row < 3; row++) {
      if (state.board[row][0] == state.activePlayer!.symbol &&
          state.board[row][1] == state.activePlayer!.symbol &&
          state.board[row][2] == state.activePlayer!.symbol) {
        return true;
      }
    }

    // check columns
    for (int col = 0; col < 3; col++) {
      if (state.board[0][col] == state.activePlayer!.symbol &&
          state.board[1][col] == state.activePlayer!.symbol &&
          state.board[2][col] == state.activePlayer!.symbol) {
        return true;
      }
    }

    // check diagonals
    if ((state.board[0][0] == state.activePlayer!.symbol &&
            state.board[1][1] == state.activePlayer!.symbol &&
            state.board[2][2] == state.activePlayer!.symbol) ||
        (state.board[0][2] == state.activePlayer!.symbol &&
            state.board[1][1] == state.activePlayer!.symbol &&
            state.board[2][0] == state.activePlayer!.symbol)) {
      return true;
    }
    return false;
  }

  void saveGame(Player playerX, Player PlayerO, String winner) {
    HistoryBox.setHistory(HistoryModel(
      playerXName: playerX.name,
      playerOName: PlayerO.name,
      winner: winner,
    ));
  }

  bool isBoardFull() {
    for (var row in state.board) {
      for (var cell in row) {
        if (cell.isEmpty) return false;
      }
    }
    return true;
  }

  void reset() {
    state = GameState(
      board: List.generate(3, (_) => List.filled(3, "")),
      activePlayer: null,
      winner: null,
    );
  }

  void startGame(Player firstPlayer) {
    state = state.copyWith(activePlayer: firstPlayer);
  }

  void setActivePlayer(Player player) {
    state = state.copyWith(activePlayer: player);
  }

}
