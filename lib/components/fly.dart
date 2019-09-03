
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:langaw/langaw-game.dart';


class Fly {

  final LangawGame game;
  List<Sprite> flyingSprite;
  Sprite deadSprite;
  double flyingSpriteIndex = 0;
  Rect flyRect;
  bool isDead = false;
  bool isOffScreen = false;
  Offset targetLocation;

  double get speed => game.tileSize * 3;

  // Construtor do Fly recebe o jogo, largura e altura
  Fly(this.game){
   setTargetLocation();
  }

  void setTargetLocation(){

    double x = game.rnd.nextDouble() * (game.screenSize.width - (game.tileSize * 2.025));
    double y = game.rnd.nextDouble() * (game.screenSize.height - (game.tileSize * 2.025));
    targetLocation = Offset(x, y);

  }

  void render(Canvas c){

    if(isDead){

      deadSprite.renderRect(c, flyRect.inflate(2));

    } else {
      flyingSprite[flyingSpriteIndex.toInt()].renderRect(c, flyRect.inflate(2));
    }


  }

  void update(double t){

    // Checa se é a mosca morreu
    // Make the fly fall
    if(isDead){

      // Se morreu, criamos um novo Rect e seta no FlyRect
      // O valor significa que não vamos mover nem para esquerda nem pra direita
      // A variavel double T é o TIMEDELTA ele possui o tempo restante desde o ultimo
      // update foi rodado. Valor em segundos

      flyRect = flyRect.translate(0, game.tileSize * 12 * t);

      //Depois de mover a mosca, checa se ela está fora da tela e a remove
      // Liberar recursos, se ela vai cair eternamente

      if(flyRect.top > game.screenSize.height){
        isOffScreen = true;
      }

    } else {

      // Clap the wings
      flyingSpriteIndex += 30 * t;
      if (flyingSpriteIndex >= 2) {
        flyingSpriteIndex -= 2;
      }

    }

    // Mover a mosca
    double stepDistance = speed * t;
    Offset toTarget = targetLocation - Offset(flyRect.left, flyRect.top);

    if(stepDistance < toTarget.distance){

      Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
      flyRect = flyRect.shift(stepToTarget);

    } else {
      flyRect = flyRect.shift(toTarget);
      setTargetLocation();
    }

  }

  void onTapDown() {

    isDead = true;
  }

}