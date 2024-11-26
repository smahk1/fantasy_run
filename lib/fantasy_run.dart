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
  // CORE LOGIC VAIRABLES //
  //======================//

  // Variables that store sprites
  late SpriteAnimationComponent player;
  late Sprite obstacleSprite;
  late SpriteAnimation obstacleAnimation;
  final Random random = Random();

  // Score varaiables

  ValueNotifier<int> score = ValueNotifier<int>(0);

  double timeTrack = 0.00;
  double timeStamp = 0;
  double scoreSpeed = 0.1;

  /// Movement related variables

  bool isJumping = false;

  // Physics-related variables for jump mechanics
  double jumpVelocity = -250; // Initial upward velocity for the jump
  double gravity = 450;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    // All UI elements (menu and others will be added later when they are built)

    overlays.add('score');

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
      // Determines how fast the layers scroll
      baseVelocity: Vector2(40, 0),
      // Layers farther in the background move slower (parallax effect)
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

    // Load all the frames into a list of Sprite objects
    final spriteFrames = await Future.wait(framePaths.map((path) async {
      final image = await images.load(path); // Load each frame as an image
      return Sprite(image); // Convert the image to a Sprite
    }));

    // Create a sprite animation using the loaded frames
    final spriteAnimation = SpriteAnimation.spriteList(
      spriteFrames,
      stepTime:
          0.1, // Duration of each frame (controls the speed of the animation)
    );

    // Create the player component with the animation
    player = SpriteAnimationComponent()
      ..animation = spriteAnimation // Assign the animation to the player
      ..size = Vector2(100, 100) // Set the size of the character
      ..position =
          Vector2(100, size.y - 150) // Position the character on the screen
      ..add(RectangleHitbox()); // hitbox for detecting collisions

    // Add the player component to the game
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
        period: 2, // Spawn obstacles every 2 seconds
        repeat: true,
        onTick: () => spawnObstacle(),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    timeTrack += dt;

    // The goal is create a counter score display that displays the score being increased continuously.
    if (timeTrack >= (timeStamp)) {
      score.value += 1;
      timeStamp += scoreSpeed;
    }

    /// In the future we will add some conditions to speed up the score
    /// We will also account for any bonus score points to reward the player through this system
    /// if(x){
    ///   scoreSpeed -= 0.05; // This should speed up the score counter
    /// }

    // Handle jump mechanics
    if (isJumping) {
      // Update the vertical position based on the current velocity
      player.position.y += jumpVelocity * dt;

      // Apply gravity to reduce the upward velocity and eventually bring the player down
      jumpVelocity += gravity * dt;

      // Stop the jump when the player reaches the ground
      if (player.position.y >= size.y - 150) {
        player.position.y = size.y - 150; // Reset the position to ground level
        isJumping = false; // Mark the jump as completed
        jumpVelocity = -200; // Reset the jump velocity for the next jump
      }
    }
  }

  @override
  void onTap() {
    if (!isJumping) {
      isJumping = true; // Start a jump if the player is not already jumping
    }
  }

  //====================//
  // Game Logic Methods //
  //====================//

  // Method to spawn a new obstacle
  void spawnObstacle() {
    final obstacle = Obstacle(sprite: obstacleSprite)
      ..position = Vector2(size.x, size.y - 90) // Start at the far-right edge
      ..size = Vector2(40, 40);
    add(obstacle);
  }
}
