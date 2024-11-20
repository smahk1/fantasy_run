import 'dart:ui';

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
        right: 30,
        child: Text(
          'Score: ${(game as FantasyRun).score}',
          style: const TextStyle(
            fontFamily: 'arcadeclassic',
            fontSize: 30,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10.0, // Glow effect
                color: Colors.black,
                offset: Offset(2, 2), // Shadow position
              ),
            ],
          ),
        ),
      );
    },
  }));
}
