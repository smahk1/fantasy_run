// Import Flame libraries for game components
import 'package:flame/components.dart';

class Obstacle extends SpriteAnimationComponent {
  final double speed; // Speed of the obstacle's horizontal movement

  Obstacle({
    required SpriteAnimation animation,
    required Vector2 position,
    required this.speed,
  }) : super(
          animation: animation,
          position: position,
          size: Vector2(40, 40), // Default size of the obstacle
        );

  @override
  void update(double dt) {
    super.update(dt);

    // Move the obstacle left by reducing its x position based on speed
    position.x -= speed * dt;

    // Remove the obstacle if it goes off-screen
    if (position.x + size.x < 0) {
      removeFromParent(); // Remove this component from the game tree
    }
  }
}
