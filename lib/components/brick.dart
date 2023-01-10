import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import '../forge2d_game_world.dart';
import 'ball.dart';
import 'package:flame/components.dart';

// 1
class Brick extends BodyComponent<Forge2dGameWorld> with ContactCallbacks {
  final Size size;
  final Vector2 position;
  final Color color;

  var destroy = false;

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Ball) {
      destroy = true;
    }
  }

  // 2
  Brick({
    required this.size,
    required this.position,
    required this.color,
  });

  @override
  void render(Canvas canvas) {
    if (body.fixtures.isEmpty) {
      return;
    }

    final rectangle = body.fixtures.first.shape as PolygonShape;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRect(
        Rect.fromCenter(
          center: rectangle.centroid.toOffset(),
          width: size.width,
          height: size.height,
        ),
        paint);
  }

  // 3
  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.static
      ..userData = this
      ..position = position
      ..angularDamping = 1.0
      ..linearDamping = 1.0;

    final brickBody = world.createBody(bodyDef);

    // 4
    final shape = PolygonShape()
      ..setAsBox(
        size.width / 2.0,
        size.height / 2.0,
        Vector2(0.0, 0.0),
        0.0,
      );

    // 5
    brickBody.createFixture(
      FixtureDef(shape)
        ..density = 100.0
        ..friction = 0.0
        ..restitution = 0.1,
    );

    return brickBody;
  }
}
