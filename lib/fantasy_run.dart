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
      ..add(RectangleHitbox());
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

  // Start the game
  void startGame() {
    overlays.remove('startMenu'); // Remove start menu
    overlays.add('score'); // Add score overlay
    overlays.add('health'); // Add health overlay
    isGameRunning = true;
    score.value = 0; // Reset score
    lives.value = 3; // Reset lives
  }

  // Pause the game
  void pauseGame() {
    isGameRunning = false; // Pause game updates
    overlays.add('pauseMenu'); // Show pause menu
  }

  // Resume the game
  void resumeGame() {
    overlays.remove('pauseMenu'); // Remove pause menu
    isGameRunning = true; // Resume game updates
  }

  // End the game
  void endGame() {
    isGameRunning = false; // Stop game updates
    overlays.remove('score'); // Remove score overlay
    overlays.remove('health'); // Remove health overlay
    overlays.add('gameOver'); // Show game over overlay
  }

  // Restart the game
  void restartGame() {
    overlays.remove('gameOver'); // Remove game over overlay
    startGame(); // Restart the game
  }

  // Return to home screen
  void returnToHome() {
    overlays.remove('gameOver'); // Remove game over overlay
    overlays.add('startMenu'); // Show start menu overlay
  }

  void resetGame() {
    // Reset score and lives
    score.value = 0;
    lives.value = 3;

    // Remove the player and any other components (e.g., obstacles)
    remove(player); // Remove the player
    children.whereType<Obstacle>().forEach(remove); // Remove all obstacles

    // Reinitialize the game state
    onLoad();

    // Show the start menu overlay
    overlays.add('startMenu');
    overlays.remove('pauseMenu');

    // Set game state to not running
    isGameRunning = false;
  }
}
