// Importing core Dart libraries for asynchronous programming and UI rendering
import 'dart:async';
import 'dart:ui';

// Importing Flame packages for game components and functionality
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';

// The main game class extends FlameGame, which provides the game loop
class FantasyRun extends FlameGame {
  // Declare a player variable to hold the animated character component
  late SpriteAnimationComponent player;

  // The onLoad method initializes the game components when the game starts
  @override
  FutureOr<void> onLoad() async {
    super.onLoad(); // Call the parent class's onLoad method

    // ============================
    // Load and Add Parallax Background
    // ============================
    // The parallax background consists of multiple layers that move at different speeds
    final parallax = await loadParallaxComponent(
      [
        // Define the image layers for the parallax effect
        ParallaxImageData('plx-1.png'),
        ParallaxImageData('plx-2.png'),
        ParallaxImageData('plx-3.png'),
        ParallaxImageData('plx-4.png'),
        ParallaxImageData('plx-5.png'),
        ParallaxImageData('plx-6.png', fill: LayerFill.none),
      ],
      // The base velocity controls the scrolling speed of the layers
      baseVelocity: Vector2(40, 0),
      // Layers further back move slower than those closer to the front
      velocityMultiplierDelta: Vector2(1.5, 1),
    );

    // Now Add the parallax background to the game
    add(parallax);

    // ============================
    // Load and Add Character Animation
    // ============================
    // List of file names for the running animation frames
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
      final image = await images.load(path);
      return Sprite(image);
    }));

    // Create an animation using the loaded frames
    final spriteAnimation = SpriteAnimation.spriteList(
      spriteFrames,
      stepTime: 0.1, // Duration of each frame
    );

    // Create the player component with the animation
    player = SpriteAnimationComponent()
      ..animation = spriteAnimation // Assign the animation to the player
      ..size = Vector2(64, 64) // Set character size
      ..position = Vector2(100, size.y - 100); // Fixed position

    // Add the player to the game
    add(player);
  }

  // The update method is called every frame to update game logic
  @override
  void update(double dt) {
    super.update(dt); // Call the parent class's update method
    // Add logic to update game objects (e.g., moving obstacles) here
  }

  // The render method is called every frame to draw game objects
  @override
  void render(Canvas canvas) {
    super.render(canvas); // Call the parent class's render method
    // Add logic to draw additional game objects here
  }
}
