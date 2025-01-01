import 'package:fantasy_run/components/overlays.dart';
import 'package:fantasy_run/fantasy_run.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Create the game instance
  FantasyRun fantasyRun = FantasyRun();

  // Set the app to fullscreen and landscape mode
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        body: GameWidget(
          game: fantasyRun,
          overlayBuilderMap: overlays,
        ),
      ),
    ),
  );
}
