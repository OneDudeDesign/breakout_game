import 'package:flame_forge2d/flame_forge2d.dart';
import 'components/ball.dart';
import 'components/arena.dart';

class Forge2dGameWorld extends Forge2DGame {
  Forge2dGameWorld() : super(gravity: Vector2.zero(), zoom: 20);

  late final Ball _ball;

  @override
  Future<void> onLoad() async {
    await _initializeGame();
    _ball.body.applyLinearImpulse(Vector2(-10, -10));
  }

  Future<void> _initializeGame() async {
    final arena = Arena();
    await add(arena);
    _ball = Ball(position: size / 2, radius: 0.5);
    await add(_ball);
  }
}
