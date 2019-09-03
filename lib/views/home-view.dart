
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:langaw/langaw-game.dart';

class HomeView {

  final LangawGame game;
  Rect titleRect;
  Sprite titleSprite;

  HomeView(this.game){

    // Seta o valor do Rect
    titleRect = Rect.fromLTWH(
        game.tileSize,
        (game.screenSize.height / 2) - (game.tileSize * 4),
        game.tileSize * 7,
        game.tileSize * 4,
    );

    // Seta a imagem o sprite
    titleSprite = Sprite('branding/title.png');
  }

  void render(Canvas c){

    // Renderiza o tileSprite passando o Canvas e o TitleRetangulo
    titleSprite.renderRect(c, titleRect);

  }

  void update(double t){}

}