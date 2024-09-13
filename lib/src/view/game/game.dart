import 'dart:math';

import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe_v2/src/data/provider/game_provider.dart';
import 'package:tic_tac_toe_v2/src/model/game.dart';
import 'package:tic_tac_toe_v2/src/model/player.dart';
import 'package:tic_tac_toe_v2/src/view/settings/settings_view.dart';
import 'package:tic_tac_toe_v2/src/view_model/game_view_model.dart';

class TicTacToeGame extends ConsumerStatefulWidget {
  const TicTacToeGame({super.key});

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends ConsumerState<TicTacToeGame> {
  late GameViewModel _gameViewModel;
  late GameState _gameState;
  late bool? _versusBot;

  late Player _player1;
  late Player _player2;
  late Player _botPlayer;

  final random = Random();

  @override
  Widget build(BuildContext context) {
    _gameState = ref.watch(gameViewModelProvider);
    _gameViewModel = ref.read(gameViewModelProvider.notifier);
    _versusBot = ref.watch(botProvider);
    _player1 = ref.watch(player1Provider);
    _player2 = ref.watch(player2Provider);
    _botPlayer = ref.watch(botPlayerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Expanded(
          child: Center(
        child: _versusBot == null
            ? gameTypeChoice()
            : _gameState.activePlayer == null
                ? firstPlayerSelection()
                : gameView(),
      )),
      floatingActionButton: _gameState.activePlayer != null
          ? FloatingActionButton(
              onPressed: () {
                _gameViewModel.reset();
              },
              child: AnimateIcon(
                key: UniqueKey(),
                onTap: () {
                  _gameViewModel.reset();
                },
                iconType: IconType.animatedOnTap,
                animateIcon: AnimateIcons.refresh,
              ),
            )
          : null,
    );
  }

  void _onCellTap(int row, int col) {
    if (_versusBot == true && _gameState.activePlayer == _botPlayer) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Not your turn !"),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    if (_gameState.board[row][col].isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This cell is already filled !"),
          duration: Duration(seconds: 1),
        ),
      );
      HapticFeedback.vibrate();
      HapticFeedback.vibrate();

      return;
    }
    _gameViewModel.updateBoard(row, col);

    if (_gameViewModel.isBoardFull()) {
      _showDialog("It's a draw!");
      if (_versusBot!) {
        _gameViewModel.saveGame(_player1, _botPlayer, "Draw");
      } else {
        _gameViewModel.saveGame(_player1, _player2, "Draw");
      }
    } else if (_gameViewModel.hasWon()) {
      _showDialog("Winner is ${_gameState.activePlayer!.name}!");

      if (_versusBot!) {
        _gameViewModel.saveGame(
            _player1, _botPlayer, _gameState.activePlayer!.name);
      } else {
        _gameViewModel.saveGame(
            _player1, _player2, _gameState.activePlayer!.name);
      }
    } else {
      if (_versusBot!) {
        _gameViewModel.setActivePlayer(
            _gameState.activePlayer == _player1 ? _botPlayer : _player1);
      } else {
        _gameViewModel.setActivePlayer(
            _gameState.activePlayer == _player1 ? _player2 : _player1);
      }
    }
  }

  void _showDialog(String title) {
    HapticFeedback.vibrate();
    _addPoint();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          actions: [
            FilledButton(
              child: const Text("New Game"),
              onPressed: () {
                _gameViewModel.reset();
                Navigator.of(ctx).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _addPoint() {}

  Widget gameTypeChoice() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            ref.read(botProvider.notifier).blabla(false);
          },
          child: const Text('Play versus human'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            ref.read(botProvider.notifier).blabla(true);
          },
          child: const Text('Play versus BOT'),
        ),
      ],
    );
  }

  Widget firstPlayerSelection() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Who starts first ?",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              _gameViewModel.setActivePlayer(_player1);
            },
            child: const Text('Player 1'),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (_versusBot!) {
                _gameViewModel.setActivePlayer(_botPlayer);

                if (_gameState.activePlayer == _botPlayer) {
                  Future.delayed(const Duration(milliseconds: 500), _botMove);
                }
              } else {
                _gameViewModel.setActivePlayer(_player2);
              }
            },
            child: _versusBot! ? const Text('Bot') : const Text('Player 2'),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (_versusBot!) {
                _gameViewModel
                    .setActivePlayer(random.nextBool() ? _player1 : _botPlayer);

                if (_gameState.activePlayer == _botPlayer) {
                  Future.delayed(const Duration(milliseconds: 500), _botMove);
                }
              } else {
                _gameViewModel
                    .setActivePlayer(random.nextBool() ? _player1 : _player2);
              }
            },
            child: const Text('Flip a coin'),
          ),
        ),
      ],
    );
  }

  /// A widget that displays the game board and updates it when the user taps
  /// on a cell. The game board is a 3x3 grid where each cell contains a 'X' or
  /// 'O' character. The characters are colored blue and red respectively.
  ///
  /// When the user taps on a cell, the [_onCellTap] function is called which
  /// updates the game state and checks if there is a winner. If there is a
  /// winner, the game is reset.
  Widget gameView() {
    if (_gameState.activePlayer == _botPlayer) {
      Future.delayed(const Duration(milliseconds: 500), _botMove);
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_gameState.activePlayer!.name),
        Flexible(
            child: Container(
          alignment: Alignment.center,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: List.generate(9, (i) {
              final row = i ~/ 3;
              final col = i % 3;
              return GestureDetector(
                onTap: () => _onCellTap(row, col),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Center(
                    child: Text(
                      _gameState.board[row][col],
                      style: TextStyle(
                        fontSize: 50,
                        fontFamily: GoogleFonts.permanentMarker().fontFamily,
                        fontWeight: FontWeight.bold,
                        color: _gameState.board[row][col] == 'X'
                            ? Colors.blue
                            : Colors.red,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ))
      ],
    );
  }

  void _botMove() {
    List<List<int>> emptyCells = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_gameState.board[i][j].isEmpty) {
          emptyCells.add([i, j]);
        }
      }
    }
    // Choisir une case vide aléatoirement
    final random = Random();
    List<int> move = emptyCells[random.nextInt(emptyCells.length)];
    _gameViewModel.updateBoard(move[0], move[1], isBotMove: true);
    _gameViewModel.setActivePlayer(_player1);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
