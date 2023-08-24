import 'dart:async';

import 'package:chochayngoaidong/components/collision_block.dart';
import 'package:chochayngoaidong/components/untils.dart';
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
  final double _gravity = 9.8;
  final double _jumpForce = 260;
  final double _terminalVelocity = 300;
  bool isOnGround = false;
  bool hasJumped = false;

  double horizontalMovement = 0;
  double moveSpeed = 100;

  List<CollisionBlock> collisionBlocks = [];

  //Xử lý di chuyển của nhân vật gồm điều hướng, tốc độ di chuyển , mặt hướng đi
  PlayerDirection playerDirection = PlayerDirection.none;

  Vector2 velocity = Vector2.zero();

  // bool isFacingRight = true;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    debugMode = true;
    // TODO: implement onLoad
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    _updatePlayerState();
    _checkHorizontalCollisons();
    _applyGravity(dt);
    _checkVerticalCollisions();
    // TODO: implement update
    super.update(dt);
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

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);
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
    if (hasJumped && isOnGround) _playerJump(dt);

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

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
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

  void _checkHorizontalCollisons() {
    for (final block in collisionBlocks) {
      // Xử lý collision
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + width;
            break;
          }
        }
      }
    }
  }

  //Xử lý trọng lực
  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        //Xử lý chạm dưới
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - width;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height;
          }
        }
      }
    }
  }
}
