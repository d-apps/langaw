
import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:langaw/langaw-game.dart';

class Backyard {

  final LangawGame game;
  Sprite bgSprite;
  Rect bgRect;

  /*

  1080 pixels ÷ 9 tiles = 120 pixels per tile

  2760 pixels ÷ 120 pixels per tile = 23 tiles

   */

  Backyard(this.game){

  // Passa o background para a imagem
  bgSprite = Sprite('bg/backyard.png');

  //
  bgRect = Rect.fromLTWH(
       0, // X - Left - Começa no zero para tomar toda largura
       game.screenSize.height - (game.tileSize * 23), // Y - Top -
       game.tileSize * 9, // Width -
       game.tileSize * 23, // Height -
   );

  }

  void render(Canvas c){

    //Desenha o sprite do background na tela
    bgSprite.renderRect(c, bgRect);
  }

  void update(double t) {

  }

}