import 'package:fantasy_run/components/overlays.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:fantasy_run/fantasy_run.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  FantasyRun game = FantasyRun();

  // recreate game every time a change is made instead of hot restarting[for testing] -- disbale when not in testing
  runApp(GameWidget(
    game: kDebugMode ? FantasyRun() : game,
    overlayBuilderMap: ui,
  ));
}
