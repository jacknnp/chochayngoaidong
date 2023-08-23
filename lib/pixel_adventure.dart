import 'dart:async';

import 'package:chochayngoaidong/components/player.dart';
import 'package:chochayngoaidong/components/level.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

// Khai báo đối tượng kế thừa từ lớp cha FlameGame
class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  PixelAdventure();
  // Khai báo các biến cần thiết đại diện cho các trạng thái thuộc tính
  late final CameraComponent cam;
  Player player = Player(character: 'Mask Dude');
  late final JoystickComponent joystick;
  bool showJoystick = false;
  Color backgroundColor() => Color.fromARGB(255, 120, 110, 196);

  // Hàm chạy đầu tiên khi ứng dụng được mở lên
  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    final world = Level(
      player: player,
      levelName: 'Level-01',
    );
    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;
    // TODO: implement onLoad
    addAll([cam, world]);

    if (showJoystick) {
      addJoystick();
    }
    return super.onLoad();
  }

// Hàm này cập nhật sẽ tự chạy khi states bên trong nó thay đổi
  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    // TODO: implement update
    super.update(dt);
  }

// Hàm cấu hình các thuộc tính của joystick - các bộ phận của joystick

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Knob.png')),
      ),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png')),
      ),
      position: Vector2(60, 350),
    );

    add(joystick);
  }

//  Hàm điều hướng các góc cho joystick - các actions
  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
}
