import 'package:fantasy_run/fantasy_run.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  FantasyRun fantasyRun = FantasyRun();

  runApp(GameWidget(game: fantasyRun));
}
