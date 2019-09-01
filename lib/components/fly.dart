
import 'package:flutter/cupertino.dart';
import 'package:langaw/langaw-game.dart';

class Fly {

  // Cria um objeto retangulo que simboliza a mosca
  Rect flyRect;
  // Cria um objeto do tipo game
  final LangawGame game;
  Paint flyPaint;
  bool isDead = false;
  bool isOffScreen = false;

  // Construtor do Fly recebe o jogo, largura e altura
  Fly(this.game, double x, double y){
   flyRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);

   // Pintura para o quadrado (retangulo)
   flyPaint = Paint();
   flyPaint.color = Color(0xff6ab04c);

  }

  void render(Canvas c){

    c.drawRect(flyRect, flyPaint);

  }

  void update(double t){

    // Checa se é a mosca morreu

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

    }

  }

  void onTapDown() {

    isDead = true;

    // Passa uma cor vermelha ao fly
    flyPaint.color = Color(0xffff4757);

    // Spawn mais moscas
    game.spawnFly();


  }

}