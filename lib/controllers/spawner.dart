
import 'package:langaw/langaw-game.dart';
import 'package:langaw/components/fly.dart';

class FlySpawner {

  final LangawGame game;

  final int maxSpawnInterval = 3000; // 3 segundos, limite de intervalo de spawnar moscas

  final int minSpawnInterval = 250; // O oposto, 1/4 de um segundo

  final int intervalChange = 3; // quantidade reduzida o currentInterval, a cada 3 secs fica mais rapido até 1/4 de um segundo, mas nunca menor,
  // limita a quantidade de moscas na tela por um momento

  final int maxFliesOnScreen = 7; // Limite de moscas na tela é no maximo 7

  int currentInterval; // armazena a quantidade de tempo a ser adicionada a partir da hora atual ao agendar o proximo spawn.

  int nextSpawn; // é a hora real agendada para o prox spawn. Essa variável possui
  // um valor que mede o tempo em milissegundos desde o início da época do Unix (1 de janeiro de 1970, 12h GMT).

  FlySpawner(this.game){

    start(); // Agenda dar spawn nas moscas a cada 3 segundos depois da instancia do controlador ser criada.
    game.spawnFly(); // Spawna as moscas.
  }

  void start(){


    killAll();  // Mata todas as moscas
    currentInterval = maxSpawnInterval; // Resetamos o intervalo atual para o máximo intervalo de spawn
    // E usando o valor acima agendamos o próximo spawn usando o linha abaixo
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;

  }

  void killAll(){

    // Esse ciclo passa por todas as moscas e seta true para todas no valor isDead
    // matando todas as moscas existentes.
    game.flies.forEach((Fly fly) => fly.isDead = true);

  }

  void update(double t){

    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;

    int livingFlies = 0;

    // Conta o numero de moscas que estão na lista e que estão vivas
    game.flies.forEach((Fly fly){

      // O código apenas loopa sobre a lista e se a mosca não está morta, adiciona uma
      // ao livingFlies
      if(!fly.isDead) livingFlies += 1;

    });

    // Checa se o tempo atual passou para o nextPawn e se o número de moscas vivas
    // é menor do que a constant maxFlieOnScreen
    if(nowTimestamp >= nextSpawn && livingFlies < maxFliesOnScreen){

      // Se atender as condições spawnamos uma mosca
      game.spawnFly();

      // Reduz o valor do currentInterval pelo valor da constant intervalChange
      // em 2% do valor do currentInterval MAS somente se o currentInterval for maior que
      // intervalo minino (minSpawnInterval)
      if(currentInterval > minSpawnInterval){

        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * 0.2).toInt();

      }

      // Finalmente nós agendamos o próximo spawn usando a hora atual com o valor
      // do currentInterval adicionado ao nextSpawn.
      nextSpawn = nowTimestamp + currentInterval;

    }

  }

  // Como é um controller não possui o método render, já que ele não possui
  // representação gráfica na tela.



}