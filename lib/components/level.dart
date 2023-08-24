import 'dart:async';

import 'package:chochayngoaidong/components/collision_block.dart';
import 'package:chochayngoaidong/components/player.dart';
import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);

    //Xử lý platform các đối tượng bên trong platform
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointLayer != null) {
      for (final spawnPoint in spawnPointLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          default:
        }
      }
    }
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collison in collisionsLayer.objects) {
        switch (collison.class_) {
          case 'Platfrom':
            final platform = CollisionBlock(
              position: Vector2(collison.x, collison.y),
              size: Vector2(collison.width, collison.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collison.x, collison.y),
              size: Vector2(collison.width, collison.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
    return super.onLoad();
  }
}
