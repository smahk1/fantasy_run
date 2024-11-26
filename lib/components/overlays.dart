import 'package:fantasy_run/fantasy_run.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext, Game)> overlays = {
  'score': (context, game) {
    // Cast the game to FantasyRun to access its score
    final FantasyRun fantasyRun = game as FantasyRun;

    return Positioned(
      top: 20,
      right: 30,
      child: ValueListenableBuilder<int>(
        valueListenable: fantasyRun.score,
        builder: (context, score, child) {
          return Text('Score:  $score',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontFamily: 'arcadeclassic',
              ));
        },
      ),
    );
  },

  /// Will add the pause menu later when needed

  // 'pause': (context) => Center(
  //       child: Container(
  //         padding: const EdgeInsets.all(16.0),
  //         color: Colors.black.withOpacity(0.7),
  //         child: const Text(
  //           'Game Paused',
  //           style: TextStyle(color: Colors.white, fontSize: 24),
  //         ),
  //       ),
  //     ),
};
