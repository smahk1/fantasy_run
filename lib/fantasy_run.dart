// Importing core Dart libraries for asynchronous programming and UI rendering
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// Importing Flame packages for game components and functionality
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/collisions.dart';

import 'components/obstacle.dart';

// The main game class extends FlameGame, which provides the game loop
// It also uses the TapDetector mixin for handling tap input events
class FantasyRun extends FlameGame with TapDetector, HasCollisionDetection {
  // Declare a variable to hold the animated character component
  late SpriteAnimationComponent player;
  // variable for holding the sprite for obstacles
  late Sprite obstacleSprite;

  // Score Variables
  int score = 0;
  late TextComponent scoreText; // text component to display the score.

  // Boolean to check if the player is currently jumping
  bool isJumping = false;

  // Physics-related variables for jump mechanics
  double jumpVelocity = -200; // Initial upward velocity for the jump
  double gravity = 400; // Gravitational force pulling the character down

  late SpriteAnimation obstacleAnimation; // Define obstacleAnimation properly
  final Random random = Random(); // Define random properly as a private field

  // The onLoad method is called when the game initializes and is used to load assets
  @override
  FutureOr<void> onLoad() async {
    super.onLoad(); // Call the parent class's onLoad method

    // ============================
    // Load and Add Parallax Background
    // ============================
    // The parallax background creates a scrolling effect with multiple layers
    final parallax = await loadParallaxComponent(
      [
        // List of image layers for the background
        ParallaxImageData('plx-1.png'),
        ParallaxImageData('plx-2.png'),
        ParallaxImageData('plx-3.png'),
        ParallaxImageData('plx-4.png'),
        ParallaxImageData('plx-5.png'),
      ],
      // The base velocity determines how fast the layers scroll
      baseVelocity: Vector2(40, 0),
      // Layers farther in the background move slower (parallax effect)
      velocityMultiplierDelta: Vector2(1.5, 1),
    );

    // Add the parallax background to the game
    add(parallax);

    // ============================
    // Load and Add Character Animation
    // ============================
    // List of file names for the running charcter animation frames
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

    // ============================
    // Add TextComponent for Score
    // ============================

    scoreText = TextComponent(
        text: 'Score: 0',
        textRenderer: TextPaint(
          style: const TextStyle(
              fontSize: 30.0, fontFamily: 'arcadeclassic', color: Colors.white),
        ),
        position: Vector2(size.x - 200, 20));

    add(scoreText);
  }
// --------------

  // Method to spawn a new obstacle
  void spawnObstacle() {
    final obstacle = Obstacle(sprite: obstacleSprite)
      ..position = Vector2(size.x, size.y - 90) // Start at the far-right edge
      ..size = Vector2(40, 40);
    add(obstacle);
  }

  // The update method is called every frame to update the game state
  @override
  void update(double dt) {
    super.update(dt); // Call the parent class's update method

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

    // score updates based on time elapsed
    score += (dt * 100).toInt(); // Increment score over time
    // print(dt);
    scoreText.text = 'Score: $score'; // Update the score text
  }

  // dt time ensures that the behaviour wrt time is normalized across high or low frame rate devices, providing same amount of changes/updates over time t.

  // The onTap method is triggered whenever the player taps the screen
  @override
  void onTap() {
    if (!isJumping) {
      isJumping = true; // Start a jump if the player is not already jumping
    }
  }

  // The render method is called every frame to draw the game objects on the screen
  @override
  void render(Canvas canvas) {
    super.render(canvas); // Call the parent class's render method
    // Additional rendering logic can be added here if needed
  }
}
