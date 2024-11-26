import 'package:fantasy_run/components/overlays.dart';
import 'package:fantasy_run/fantasy_run.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';

void main() {
  FantasyRun fantasyRun = FantasyRun();

  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(GameWidget(
    game: kDebugMode ? FantasyRun() : fantasyRun,
    overlayBuilderMap: overlays,
  ));
}
