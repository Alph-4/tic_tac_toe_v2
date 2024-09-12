import 'package:flutter/material.dart';
import 'package:tic_tac_toe_v2/src/view/game/game.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TicTacToeGame(),
                  ),
                );
              },
              child: const Text('Local Game'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                // TODO: Implement online game
              },
              child: const Text('Online Game'),
            ),
          ],
        ),
      ),
    );
  }
}
