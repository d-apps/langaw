
import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';

import 'package:langaw/components/backyard.dart';
import 'package:langaw/components/fly.dart';
import 'package:langaw/components/house-fly.dart';

import 'package:langaw/components/agile-fly.dart';
import 'package:langaw/components/drooler-fly.dart';
import 'package:langaw/components/hungry-fly.dart';
import 'package:langaw/components/macho-fly.dart';

class LangawGame extends Game {

  Size screenSize;
  double tileSize;
  List<Fly> flies;
  Random rnd;

  Backyard backyard;

  // Necessário criar o inicialiador para receber o tamanho da tela
  LangawGame(){
    initialize();
  }

  void initialize()async {

    // Inicializa/ Instancia a lista de moscas que está nula
    flies = List<Fly>();

    // Inializa o random
    rnd = Random();

    // Aqui o método initialDimensions é um Future<Size> que espera até receber o tamanho.
    // Após termos o valor ele seta o valor diretamente no objeto screenSize, porém
    // Porém precisa recalcular o tileSize
    resize(await Flame.util.initialDimensions());

    //Inicializa o background
    backyard = Backyard(this);

    // Começa mostrar as moscas
    spawnFly();
  }

  void spawnFly(){

    // Gera um numero randomico e multipica pelo valor resultado do valor da
    // do tamanho da altura/largura menos o tileSize
    double x = rnd.nextDouble() * (screenSize.width - (tileSize * 2.025));
    double y = rnd.nextDouble() * (screenSize.height - (tileSize * 2.025));

    print("RANDOM ${rnd.nextDouble()}");

    //flies.add(HouseFly(this, x, y));

    switch (rnd.nextInt(5)) {
      case 0:
        flies.add(HouseFly(this, x, y));
        break;
      case 1:
        flies.add(DroolerFly(this, x, y));
        break;
      case 2:
        flies.add(AgileFly(this, x, y));
        break;
      case 3:
        flies.add(MachoFly(this, x, y));
        break;
      case 4:
        flies.add(HungryFly(this, x, y));
        break;
    }

  }

  void render(Canvas canvas) {

    // Background
    /*
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff576574);
    canvas.drawRect(bgRect, bgPaint);
    */

    // Mostra o background
    backyard.render(canvas);

    // Verifica se a mosca está morta, se não ela fica voando
    flies.forEach((Fly fly) => fly.render(canvas));

  }

  void update(double t) {

    // Atualiza a mosca
    flies.forEach((Fly fly) => fly.update(t));

    // Remove a mosca que está fora da tela
    flies.removeWhere((Fly fly) => fly.isOffScreen);

  }


  void resize(Size size){

    screenSize = size;

    // Aspect Ratio 16:9
    //Largura divido por 9, signfica que cabem ate 9 moscas na tela, left to the right
    tileSize = screenSize.width / 9;

    print("TILESIZE: $tileSize");

    super.resize(size);

  }

  void onTapDown(TapDownDetails d){

    flies.forEach((Fly fly){

      // Se o flyRect do fly (posição chamada) possui o offset, tocou dentro do
      // Rect, chama o tap da class

      if(fly.flyRect.contains(d.globalPosition)){

        // Chama o tap da classe Fly
        fly.onTapDown();

      }

    });

  }

}