// Import Flame libraries for game components
import 'package:flame/components.dart';
// Import Flame libraries for collision components
import 'package:flame/collisions.dart';

class Obstacle extends SpriteComponent with CollisionCallbacks {
  final double speed = 100; // Speed of the obstacle's horizontal movement

  Obstacle({required Sprite sprite}) {
    this.sprite = sprite; // Assign the sprite for the obstacle
    add(RectangleHitbox()); // Add a rectangular hitbox for collision detection
  }

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

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Handle collision with the player
    if (other is SpriteAnimationComponent) {
      // player sprite turns red after collision
      print('collision');
    }
  }
}
