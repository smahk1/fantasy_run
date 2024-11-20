import 'package:fantasy_run/fantasy_run.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  // using FantasyRun to make "game" object as a game window
  FantasyRun game = FantasyRun();
  // recreate game every time a change is made instead of hot restarting[for testing] -- disbale when not in testing
  runApp(GameWidget(game: kDebugMode ? FantasyRun() : game, overlayBuilderMap: {
    // Define the overlay for the score
    'scoreOverlay': (context, game) {
      return Positioned(
        top: 20,
        right: 20,
        child: Text(
          'Score: ${(game as FantasyRun).score}',
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      );
    },
  }));
}
