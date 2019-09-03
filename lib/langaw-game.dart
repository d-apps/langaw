
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

import 'package:langaw/view.dart';
import 'package:langaw/views/home-view.dart';

import 'package:langaw/components/start-button.dart';
import 'package:langaw/views/lost-view.dart';

import 'package:langaw/controllers/spawner.dart';

import 'package:langaw/components/credits-button.dart';
import 'package:langaw/components/help-button.dart';

import 'package:langaw/views/help-view.dart';
import 'package:langaw/views/credits-view.dart';


class LangawGame extends Game {

  Size screenSize;
  double tileSize;
  List<Fly> flies;
  Random rnd;

  Backyard backyard;

  View activeView = View.home;
  HomeView homeView;
  StartButton startButton;
  LostView lostView;
  HelpView helpView;
  CreditsView creditsView;

  FlySpawner spawner;

  HelpButton helpButton;
  CreditsButton creditsButton;

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

    // Inicializa depois do metodo resize para sabermos o tamanho da tela
    homeView = HomeView(this);
    startButton = StartButton(this);
    lostView = LostView(this);
    spawner = FlySpawner(this);
    helpButton = HelpButton(this);
    creditsButton = CreditsButton(this);
    helpView = HelpView(this);
    creditsView = CreditsView(this);

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

    // 1 - Mostra o background
    backyard.render(canvas);

    // 2 - Verifica se a mosca está morta, se não ela fica voando
    flies.forEach((Fly fly) => fly.render(canvas));

    // 3-  Renderiza a home por último
    // Checamos sse o enum da view é do tipo home, se for mostra o título em cima
    // de tudo.
    if (activeView == View.home) homeView.render(canvas);

    // Se o activeView for igual home ou lost, mostra o botão também
    if(activeView == View.home || activeView == View.lost) {

      // Se a view está na home ou na perdeu:
      startButton.render(canvas);
      helpButton.render(canvas);
      creditsButton.render(canvas);
    }

    if (activeView == View.lost) lostView.render(canvas);

    if (activeView == View.help) helpView.render(canvas);
    if (activeView == View.credits) creditsView.render(canvas);

  }

  void update(double t) {

    // Atualiza a mosca
    flies.forEach((Fly fly) => fly.update(t));

    // Remove a mosca que está fora da tela
    flies.removeWhere((Fly fly) => fly.isOffScreen);

    // Controlador que spawna as moscas
    spawner.update(t);

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

    bool isHandled = false;

        // dialog boxes
        if (!isHandled) {
          if (activeView == View.help || activeView == View.credits) {
            activeView = View.home;
            isHandled = true;
          }
        }


        // help button
        if (!isHandled && helpButton.rect.contains(d.globalPosition)) {
          if (activeView == View.home || activeView == View.lost) {
            helpButton.onTapDown();
            isHandled = true;
          }
        }

        // credits button
        if (!isHandled && creditsButton.rect.contains(d.globalPosition)) {
          if (activeView == View.home || activeView == View.lost) {
            creditsButton.onTapDown();
            isHandled = true;
          }
        }

        // START BUTTON
        if(!isHandled && startButton.rect.contains(d.globalPosition)){
          if(activeView == View.home || activeView == View.lost){
            startButton.onTapDown();
            isHandled = true;
          }
        }

    // CHECA SE TOCOU NA MOSCA
    if (!isHandled){

      bool didHitAFly = false;
      flies.forEach((Fly fly){

        // Se o flyRect do fly (posição chamada) possui o offset, tocou dentro do
        // Rect, chama o tap da class
        if(fly.flyRect.contains(d.globalPosition)){

          // Chama o tap da classe Fly
          fly.onTapDown();
          isHandled = true;
          didHitAFly = true;

        }

      });

      // Checa se perdeu, se sim muda a active view para status lost
      if (activeView == View.playing && !didHitAFly) {
        activeView = View.lost;
      }

    }

  }

}