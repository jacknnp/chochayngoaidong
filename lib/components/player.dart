import 'dart:async';

import 'package:chochayngoaidong/pixel_adventure.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

// 2 trạng thái của nhân vật
enum PlayerState { idle, running }

// 3 trạng thái di chuyển của nhân vật
enum PlayerDirection { left, right, none }

// Khai báo đối tượng nhân vật
class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  //Khai báo các biến cần thiết đại diên cho các state
  String character;
  Player({position, this.character = 'Ninja Frog'}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05;

  //Xử lý di chuyển của nhân vật gồm điều hướng, tốc độ di chuyển , mặt hướng đi
  PlayerDirection playerDirection = PlayerDirection.none;

  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    _updatePlayerState();
    // TODO: implement update
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    // TODO: implement onLoad
    return super.onLoad();
  }

// Hàm xử lý khi có dự kiện trên bàn phím
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Optimize lại code cho ngắn gọn
    horizontalMovement = 0;
    // TODO: implement onKeyEvent
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    // if (isLeftKeyPressed && isRightKeyPressed) {
    //   playerDirection = PlayerDirection.none;
    // } else if (isLeftKeyPressed) {
    //   playerDirection = PlayerDirection.left;
    // } else if (isRightKeyPressed) {
    //   playerDirection = PlayerDirection.right;
    // } else {
    //   playerDirection = PlayerDirection.none;
    // }

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    runningAnimation = _spriteAnimation('Run', 11);

    idleAnimation = _spriteAnimation('Idle', 11);

    //List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation
    };
    //Set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$state (32x32).png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: Vector2.all(32)));
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
    //   double dirX = 0.0;
    //   switch (playerDirection) {
    //     case PlayerDirection.left:
    //       if (isFacingRight) {
    //         flipHorizontallyAroundCenter();
    //         isFacingRight = false;
    //       }
    //       current = PlayerState.running;
    //       dirX -= moveSpeed;
    //       break;
    //     case PlayerDirection.right:
    //       if (!isFacingRight) {
    //         flipHorizontallyAroundCenter();
    //         isFacingRight = true;
    //       }
    //       current = PlayerState.running;
    //       dirX += moveSpeed;
    //       break;
    //     case PlayerDirection.none:
    //       break;
    //     default:
    //   }

    //   velocity = Vector2(dirX, 0.0);
    //   position += velocity * dt;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // Kiểm tra actor đang di chuyển thì chuyển sang trạng thái running
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;
    current = playerState;
  }
}
