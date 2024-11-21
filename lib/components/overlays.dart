import 'package:flutter/material.dart';
import 'package:fantasy_run/fantasy_run.dart'; // Import your game class

Map<String, Widget Function(BuildContext, FantasyRun)> overlayBuilderMap = {
  'scoreOverlay': (context, game) {
    return Positioned(
      top: 20,
      right: 30,
      child: ValueListenableBuilder<int>(
        // Value of score is tracked here and upon changes the widget is rebuilt accordingly
        valueListenable: game.score,
        builder: (context, score, child) {
          return Text(
            'Score: $score',
            style: const TextStyle(
              fontFamily: 'arcadeclassic',
              fontSize: 30,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          );
        },
      ),
    );
  },

  // Other overlays can be defined here
};
