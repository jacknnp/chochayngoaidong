import 'dart:async';

import 'package:chochayngoaidong/actors/player.dart';
import 'package:chochayngoaidong/levels/level.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  PixelAdventure();

  late final CameraComponent cam;
  Player player = Player(character: 'Mask Dude');
  late final JoystickComponent joystick;
  Color backgroundColor() => Color.fromARGB(255, 120, 110, 196);
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
    addJoystick();
    return super.onLoad();
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Knob.png')),
      ),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png')),
      ),
      margin: const EdgeInsets.only(left: 32, right: 32),
      position: Vector2(40, 150),
    );

    add(joystick);
  }
}
