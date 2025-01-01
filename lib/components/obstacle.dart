import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:fantasy_run/fantasy_run.dart';

class Obstacle extends SpriteComponent with CollisionCallbacks, HasGameRef {
  final double speed = 200; // Speed of the obstacle's horizontal movement

  Obstacle({required Sprite sprite}) {
    this.sprite = sprite; // Assign the sprite for the obstacle
    size = Vector2(40, 40); // Set default size for obstacles
    anchor = Anchor.center; // Ensure hitbox alignment
    add(RectangleHitbox()); // Add a rectangular hitbox for collision detection
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move the obstacle left by reducing its x position
    position.x -= speed * dt;

    // Remove the obstacle if it goes off-screen
    if (position.x + size.x < 0) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Handle collision with the player
    if (other is SpriteAnimationComponent) {
      // Access the game and reduce the player's lives
      (gameRef as FantasyRun).lives.value -= 1;

      // Remove the obstacle after a collision
      removeFromParent();
    }
  }
}
