import 'package:flame_forge2d/flame_forge2d.dart';

import '../forge2d_game_world.dart';
import 'package:flutter/rendering.dart';

import 'package:flame/extensions.dart';

// 1
class Ball extends BodyComponent<Forge2dGameWorld> {
  // 2
  final Vector2 position;
  final double radius;

  Ball({required this.position, required this.radius});

  final _gradient = RadialGradient(
    center: Alignment.topLeft,
    colors: [
      const HSLColor.fromAHSL(1.0, 0.0, 0.0, 1.0).toColor(),
      const HSLColor.fromAHSL(1.0, 0.0, 0.0, 0.9).toColor(),
      const HSLColor.fromAHSL(1.0, 0.0, 0.0, 0.4).toColor(),
    ],
    stops: const [0.0, 0.5, 1.0],
    radius: 0.95,
  );

  //1
  @override
  void render(Canvas canvas) {
    // 2
    final circle = body.fixtures.first.shape as CircleShape;

    // 3
    final paint = Paint()
      ..shader = _gradient.createShader(Rect.fromCircle(
        center: circle.position.toOffset(),
        radius: radius,
      ))
      ..style = PaintingStyle.fill;

    // 4
    canvas.drawCircle(circle.position.toOffset(), radius, paint);
  }

  // 3
  @override
  Body createBody() {
    // 4
    final bodyDef = BodyDef()
      ..userData = this
      ..type = BodyType.dynamic
      ..position = position;

    // 5
    final ball = world.createBody(bodyDef);

    // 6
    final shape = CircleShape()..radius = radius;

    // 7
    final fixtureDef = FixtureDef(shape)
      ..restitution = 1.0
      ..density = 1.0;

    // 8
    ball.createFixture(fixtureDef);
    return ball;
  }

  void reset() {
    body.setTransform(position, angle);
    body.angularVelocity = 0.0;
    body.linearVelocity = Vector2.zero();
  }
}
