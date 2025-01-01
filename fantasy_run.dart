import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'components/obstacle.dart';

class FantasyRun extends FlameGame with TapDetector, HasCollisionDetection {
  //======================//
  // CORE LOGIC VARIABLES //
  //======================//

  // Variables that store sprites
  late SpriteAnimationComponent player;
  late Sprite obstacleSprite;

  // Used for random obstacle/enemy spawns
  final Random random = Random();

  // Score and lives variables
  ValueNotifier<int> score = ValueNotifier<int>(0);
  ValueNotifier<int> lives = ValueNotifier<int>(3);

  // Game state variables
  bool isGameRunning = false;

  double timeTrack = 0.00;
  double timeStamp = 0;
  double scoreSpeed = 0.1;

  // Movement-related variables
  bool isJumping = false;
  double jumpVelocity = -250; // Initial upward velocity for the jump
  double gravity = 450;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    overlays.add('startMenu'); // Show start menu overlay initially

    //==================================//
    // Load and Add Parallax Background //
    //==================================//
    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('plx-1.png'),
        ParallaxImageData('plx-2.png'),
        ParallaxImageData('plx-3.png'),
        ParallaxImageData('plx-4.png'),
        ParallaxImageData('plx-5.png'),
      ],
      baseVelocity: Vector2(40, 0),
      velocityMultiplierDelta: Vector2(1.5, 1),
    );
    add(parallax);

    //===================================//
    // Load and Add Character Animations //
    //===================================//
    final framePaths = [
      'run_frame_1.png',
      'run_frame_2.png',
      'run_frame_3.png',
      'run_frame_4.png',
      'run_frame_5.png',
      'run_frame_6.png',
      'run_frame_7.png',
      'run_frame_8.png',
    ];
    final spriteFrames = await Future.wait(framePaths.map((path) async {
      final image = await images.load(path);
      return Sprite(image);
    }));
    final spriteAnimation = SpriteAnimation.spriteList(
      spriteFrames,
      stepTime: 0.1,
    );
    player = SpriteAnimationComponent()
      ..animation = spriteAnimation
      ..size = Vector2(100, 100)
      ..position = Vector2(100, size.y - 150)
      ..add(RectangleHitbox()
        ..size = Vector2(80,
            80) // Set the hitbox size smaller (e.g., 80% of the sprite's size)
        ..position = Vector2(10,
            10)); // Position the hitbox to match the player's sprite (optional)

    add(player);

    // ============================
    // Load Obstacle Sprite
    // ============================
    final obstacleImage = await images.load('rock-1.png');
    obstacleSprite = Sprite(obstacleImage);

    // ==========================
    // Add Obstacle Spawner Timer
    // ==========================
    add(
      TimerComponent(
        period: 2,
        repeat: true,
        onTick: () => spawnObstacle(),
      ),
    );
  }

  @override
  void update(double dt) {
    if (!isGameRunning) return;

    super.update(dt);
    timeTrack += dt;

    if (timeTrack >= (timeStamp)) {
      score.value += 1;
      timeStamp += scoreSpeed;
    }

    if (isJumping) {
      player.position.y += jumpVelocity * dt;
      jumpVelocity += gravity * dt;
      if (player.position.y >= size.y - 150) {
        player.position.y = size.y - 150;
        isJumping = false;
        jumpVelocity = -250;
      }
    }

    // End the game if lives reach 0
    if (lives.value <= 0) {
      endGame();
    }
  }

  @override
  void onTap() {
    if (!isGameRunning || isJumping) return;

    isJumping = true;
  }

  void spawnObstacle() {
    if (!isGameRunning) return;

    final obstacle = Obstacle(sprite: obstacleSprite)
      ..position = Vector2(size.x, size.y - 90)
      ..size = Vector2(40, 40);
    add(obstacle);
  }

  void startGame() {
    overlays.remove('startMenu');
    overlays.add('score');
    overlays.add('health');
    overlays.add('pauseButton');
    isGameRunning = true;
    score.value = 0;
    lives.value = 3;
  }

  void pauseGame() {
    isGameRunning = false;
    overlays.add('pauseMenu');
  }

  // Resume the game
  void resumeGame() {
    overlays.remove('pauseMenu');
    isGameRunning = true;
  }

  void endGame() {
    isGameRunning = false;
    overlays.remove('score');
    overlays.remove('health');
    overlays.add('gameOver');
  }

  void restartGame() {
    overlays.remove('gameOver');
    resetGame();
    startGame();
  }

  void returnToHome() {
    overlays.remove('gameOver');
    overlays.add('startMenu');
  }

  void resetGame() {
    // Reset score and lives
    score.value = 0;
    lives.value = 3;

    // Remove all obstacles and other children from the game
    final componentsToRemove = children.toList();
    for (var component in componentsToRemove) {
      remove(component);
    }

    // Reset time-related variables
    timeTrack = 0.00;
    timeStamp = 0;

    // Reset player state
    isJumping = false;
    jumpVelocity = -250;
    gravity = 450;

    // Reset game state variables
    isGameRunning = false;

    // Reload the game from scratch
    onLoad();
  }
}
