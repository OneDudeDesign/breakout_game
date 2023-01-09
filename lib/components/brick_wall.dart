// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import '../forge2d_game_world.dart';
import 'brick.dart';

// 1
class BrickWall extends Component with HasGameRef<Forge2dGameWorld> {
  final Vector2 position;
  final Size? size;
  final int rows;
  final int columns;
  final double gap;

  // 2
  BrickWall({
    Vector2? position,
    this.size,
    int? rows,
    int? columns,
    double? gap,
  })  : position = position ?? Vector2.zero(),
        rows = rows ?? 1,
        columns = columns ?? 1,
        gap = gap ?? 0.1;

  // 3
  @override
  Future<void> onLoad() async {
    await _buildWall();
  }

  Future<void> _buildWall() async {
    // 1
    final wallSize = size ??
        Size(
          gameRef.size.x,
          gameRef.size.y * 0.25,
        );

    // 2
    final brickSize = Size(
      ((wallSize.width - gap * 2.0) - (columns - 1) * gap) / columns,
      (wallSize.height - (rows - 1) * gap) / rows,
    );

    // 3
    var brickPosition = Vector2(
      brickSize.width / 2.0 + gap,
      brickSize.height / 2.0 + position.y,
    );

    // 4
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < columns; j++) {
        await add(Brick(
          size: brickSize,
          position: brickPosition,
        ));
        brickPosition += Vector2(brickSize.width + gap, 0.0);
      }
      brickPosition += Vector2(
        (brickSize.width / 2.0 + gap) - brickPosition.x,
        brickSize.height + gap,
      );
    }
  }

  @override
  void update(double dt) {
    // Check for bricks in the wall that have been flagged for removal.
    // Note: this is a destructive process so iterate over a copy of
    // the elements and not the actual list of children and fixtures.
    //
    for (final child in [...children]) {
      if (child is Brick && child.destroy) {
        for (final fixture in [...child.body.fixtures]) {
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
      }
    }

    super.update(dt);
  }
}