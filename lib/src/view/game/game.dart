import 'dart:math';

import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe_v2/src/model/player.dart';
import 'package:tic_tac_toe_v2/src/view/settings/settings_view.dart';

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<List<String>> _board =
      List.generate(3, (i) => List.generate(3, (j) => ""), growable: false);

  Player? _activePlayer;
  final random = Random();

  var player1 = Player("Joueur 1", "X");
  var player2 = Player("Joueur 2", "O");
  var bot = Player("Bot", "O");
  bool? _versusBot;
  Player? _winner;

  void _onCellTap(int row, int col) {
    if (_winner != null || _board[row][col].isNotEmpty) return;

    setState(() {
      _board[row][col] = _activePlayer!.symbol;

      if (hasWon()) {
        _winner = _activePlayer;
        _showDialog("Winner is ${_winner!.name}!");
      } else if (isBoardFull()) {
        _showDialog("It's a draw!");
      } else {
        _activePlayer = _versusBot!
            ? (_activePlayer == player1 ? bot : player1)
            : (_activePlayer == player1 ? player2 : player1);

        if (_activePlayer == bot) {
          Future.delayed(const Duration(milliseconds: 500), _botMove);
        }
      }
    });
  }

  void _showDialog(String title) {
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
                _reset();

                Navigator.of(ctx).pop();
              },
            )
          ],
        );
      },
    );
  }

  bool isBoardFull() {
    for (var row in _board) {
      for (var cell in row) {
        if (cell.isEmpty) return false;
      }
    }
    return true;
  }

  Widget gameTypeChoice() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FilledButton(
          onPressed: () {
            setState(() {
              _versusBot = false;
            });
          },
          child: const Text('Play versus human'),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            setState(() {
              _versusBot = true;
            });
          },
          child: const Text('Play versus bot'),
        ),
      ],
    );
  }

  bool hasWon() {
    // check rows
    for (int row = 0; row < 3; row++) {
      if (_board[row][0] == _activePlayer!.symbol &&
          _board[row][1] == _activePlayer!.symbol &&
          _board[row][2] == _activePlayer!.symbol) {
        return true;
      }
    }

    // check columns
    for (int col = 0; col < 3; col++) {
      if (_board[0][col] == _activePlayer!.symbol &&
          _board[1][col] == _activePlayer!.symbol &&
          _board[2][col] == _activePlayer!.symbol) {
        return true;
      }
    }

    // check diagonals
    if ((_board[0][0] == _activePlayer!.symbol &&
            _board[1][1] == _activePlayer!.symbol &&
            _board[2][2] == _activePlayer!.symbol) ||
        (_board[0][2] == _activePlayer!.symbol &&
            _board[1][1] == _activePlayer!.symbol &&
            _board[2][0] == _activePlayer!.symbol)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: _versusBot == null
            ? gameTypeChoice()
            : _activePlayer == null
                ? firstPlayerSelection()
                : gameView(),
      ),
      floatingActionButton: _activePlayer != null
          ? FloatingActionButton(
              onPressed: () {
                _reset();
              },
              child: AnimateIcon(
                key: UniqueKey(),
                onTap: () {
                  _reset();
                },
                iconType: IconType.animatedOnTap,
                animateIcon: AnimateIcons.refresh,
              ),
            )
          : null,
    );
  }

  Widget firstPlayerSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Who starts first ?"),
        SizedBox(
          height: 16,
        ),
        FilledButton(
          onPressed: () {
            setState(() {
              _activePlayer = player1;
            });
          },
          child: const Text('Player 1'),
        ),
        const SizedBox(width: 20),
        FilledButton(
          onPressed: () {
            setState(() {
              if (_versusBot!) {
                _activePlayer = bot;
                if (_activePlayer == bot) {
                  Future.delayed(Duration(milliseconds: 500), _botMove);
                }
              } else {
                _activePlayer = player2;
              }
            });
          },
          child: _versusBot! ? const Text('Bot') : const Text('Player 2'),
        ),
        const SizedBox(width: 20),
        FilledButton(
          onPressed: () {
            setState(() {
              if (_versusBot!) {
                _activePlayer = random.nextBool() ? player1 : bot;
                if (_activePlayer == bot) {
                  Future.delayed(Duration(milliseconds: 500), _botMove);
                }
              } else {
                _activePlayer = random.nextBool() ? player1 : player2;
              }
            });
          },
          child: const Text('Flip a coin'),
        ),
        ElevatedButton.icon(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () {
              setState(() {
                _versusBot = null;
              });
            },
            label: Text("Back"))
      ],
    );
  }

  Widget gameView() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_activePlayer!.name),
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
                      _board[row][col],
                      style: TextStyle(
                        fontSize: 50,
                        fontFamily: GoogleFonts.permanentMarker().fontFamily,
                        fontWeight: FontWeight.bold,
                        color:
                            _board[row][col] == 'X' ? Colors.blue : Colors.red,
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
    // Liste des cases vides
    List<List<int>> emptyCells = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j].isEmpty) {
          emptyCells.add([i, j]);
        }
      }
    }
    // Choisir une case vide aléatoirement
    final random = Random();
    List<int> move = emptyCells[random.nextInt(emptyCells.length)];
    _onCellTap(move[0], move[1]);
  }

  void _reset() {
    setState(() {
      _activePlayer = null;
      _winner = null;
      _board = List.generate(3, (_) => List.filled(3, ''));
    });
  }
}
