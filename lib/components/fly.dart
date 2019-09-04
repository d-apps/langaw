
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:langaw/langaw-game.dart';
import 'package:langaw/view.dart';
import 'package:langaw/components/callout.dart';


class Fly {

  final LangawGame game;
  List<Sprite> flyingSprite;
  Sprite deadSprite;
  double flyingSpriteIndex = 0;
  Rect flyRect;
  bool isDead = false;
  bool isOffScreen = false;
  Offset targetLocation;
  Callout callout;

  double get speed => game.tileSize * 3;

  // Construtor do Fly recebe o jogo, largura e altura
  Fly(this.game){
    callout = Callout(this);
   setTargetLocation();

  }

  void setTargetLocation(){

    double x = game.rnd.nextDouble() * (game.screenSize.width - (game.tileSize * 2.025));
    double y = game.rnd.nextDouble() * (game.screenSize.height - (game.tileSize * 2.025));
    targetLocation = Offset(x, y);

  }

  void render(Canvas c) {
    if (isDead) {
      deadSprite.renderRect(c, flyRect.inflate(2));
    } else {
      flyingSprite[flyingSpriteIndex.toInt()].renderRect(c, flyRect.inflate(2));
      if (game.activeView == View.playing) {
        callout.render(c);
      }
    }
  }

  void update(double t) {
    if (isDead) {
      // make the fly fall
      flyRect = flyRect.translate(0, game.tileSize * 12 * t);
      if (flyRect.top > game.screenSize.height) {
        isOffScreen = true;
      }
    } else {
      // flap the wings
      flyingSpriteIndex += 30 * t;

      //if (flyingSpriteIndex >= 2) {
      //  flyingSpriteIndex -= 2;
      //}

      while (flyingSpriteIndex >= 2) {
        flyingSpriteIndex -= 2;
      }

      // move the fly
      double stepDistance = speed * t;
      Offset toTarget = targetLocation - Offset(flyRect.left, flyRect.top);
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
        flyRect = flyRect.shift(stepToTarget);
      } else {
        flyRect = flyRect.shift(toTarget);
        setTargetLocation();
      }

      // callout
      callout.update(t);
    }
  }

  void onTapDown() {

    isDead = true;

    if(game.activeView == View.playing){
      game.score += 1;

      if(game.score > (game.storage.getInt('highscore') ?? 0)){
        game.storage.setInt('highscore', game.score);
        game.highscoreDisplay.updateHighscore();
      }

    }

  }

}