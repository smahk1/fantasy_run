// Importing core Dart libraries for asynchronous programming and UI rendering
import 'dart:async';
import 'dart:math';

// Importing Flame packages for game components and functionality
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'components/obstacle.dart'; // Import the obstacle class
import 'package:flutter/foundation.dart'; // Used for value notifiers

// Using the TapDetector mixin for handling tap input events
class FantasyRun extends FlameGame with TapDetector {
  // Varaible to hold animatied character components
  late SpriteAnimationComponent player;

  ///=============================///
  /// All score related variables ///
  ///=============================///

  ValueNotifier<int> score = ValueNotifier<int>(0); // The score

  double timeTrack = 0.00;
  double timeStamp = 0;
  double scoreSpeed = 0.1;

  ///==============================///
  /// All Health related variables ///
  ///==============================///

  bool isDead = false;
  int health = 1;

  ///================================///
  /// All Movement related variables ///
  ///================================///

  bool isJumping = false;

  // Physics-related variables for jump mechanics
  double jumpVelocity = -250; // Initial upward velocity for the jump
  double gravity = 450;

  late SpriteAnimation obstacleAnimation;
  final Random random = Random();

  // The onLoad method is called when the game initializes and is used to load assets
  @override
  FutureOr<void> onLoad() async {
    super.onLoad(); // Call the parent class's onLoad method

    overlays.add('scoreOverlay');

    //==================================//
    // Load and Add Parallax Background //
    //==================================//

    // List of image layers for the background
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

    //==================================//
    // Load and Add Character Animation //
    //==================================//

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
          Vector2(100, size.y - 150); // Position the character on the screen

    // Add the player component to the game
    add(player);

    // ============================
    // Load and Add Obstacle Animation
    // ============================

    final obstacleFrames = [
      await images.load('rock-1.png'),
      await images.load('rock-2.png'),
    ];
    obstacleAnimation = SpriteAnimation.spriteList(
      obstacleFrames.map((image) => Sprite(image)).toList(),
      stepTime: 0.5,
    );

    // Start spawning obstacles
    _spawnObstacles();
  }

  // Custom periodic execution method for spawning obstacles
  void _spawnObstacles() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 2)); // Delay for 2 seconds
      final position = Vector2(size.x, size.y - 90);
      final speed = 400 + random.nextDouble() * 50; // Randomize speed
      add(Obstacle(
        animation: obstacleAnimation,
        position: position,
        speed: speed,
      ));
    }
  }

  // The update method is called every frame to update the game state
  @override
  void update(double dt) {
    super.update(dt); // Call the parent class's update method

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

  // dt ensures that the vertical behaviour of the character is normalized across high or low frame rate devices, providing same amount of movement over time t.

  // The onTap method is triggered whenever the player taps the screen
  @override
  void onTap() {
    if (!isJumping) {
      isJumping = true; // Start a jump if the player is not already jumping
    }
  }
}
