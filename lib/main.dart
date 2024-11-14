import 'package:fantasy_run/fantasy_run.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  // Using the class we made for QuestClear to make the "game" object to create the first game window
  FantasyRun game = FantasyRun();
  runApp(GameWidget(game: kDebugMode ? FantasyRun() : game));
}
