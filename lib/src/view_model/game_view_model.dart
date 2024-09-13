import 'package:riverpod/riverpod.dart';
import 'package:tic_tac_toe_v2/src/data/model/history_hive_model.dart';
import 'package:tic_tac_toe_v2/src/data/source/local/history_box.dart';
import 'package:tic_tac_toe_v2/src/model/game.dart';
import 'package:tic_tac_toe_v2/src/model/player.dart';

final gameViewModelProvider =
    AutoDisposeStateNotifierProvider<GameViewModel, GameState>((ref) {
  return GameViewModel();
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
  GameViewModel()
      : super(GameState(
          board: List.generate(3, (_) => List.filled(3, "")),
          activePlayer: null,
          winner: null,
        ));

  void updateBoard(int row, int col, {bool isBotMove = false}) {
    state.board[row][col] = state.activePlayer!.symbol;
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

  void saveGame(Player playerX, Player PlayerY, String winner) {
    HistoryBox.setHistory(HistoryModelHive(
      playerXName: playerX.name,
      playerOName: PlayerY.name,
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    reset();
  }
}
