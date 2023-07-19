import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import '../../data/player.dart';
import '../../data/players_dao.dart';
import '../../data/tasks_dao.dart';
import '../helper/dialog.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  late CountdownTimerController controller =
      CountdownTimerController(endTime: endTime);
  var playerdao;
  var taskdao;
  String tasktext = "Not inicialized";
  var rand = Random();

  @override
  void initState() {
    super.initState();
    playerdao = context.read<PlayerDao>();
    taskdao = context.read<TaskDao>();
    updatePlayers();
    getTasks();
    controller = CountdownTimerController(endTime: endTime);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            "assets/images/logo.jpg",
            height: 300,
            width: 300,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CountdownTimer(
              controller: controller,
              endTime: endTime,
              textStyle: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(15)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.primary),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 3.0))),
              ),
              onPressed: () {
                endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
                controller = CountdownTimerController(endTime: endTime);
                getText().then((text) => {
                      setState(() {
                        tasktext = text;
                      })
                    });
                setState(() {});
              },
              child: const Text("NEEEEXT",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ]),
          Container(
            margin: const EdgeInsets.all(30),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: Text(tasktext,
                style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(20)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 3.0))),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/starting");
                },
                child: const Text("END GAME",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(20)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.secondary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                              color: Colors.black, width: 3.0))),
                ),
                onPressed: () {
                  AddPlayerDialog(context, "ADD NAME:", playerdao)
                      .then((onValue) {
                    playerdao.savePlayer(Player(onValue, true));
                    updatePlayers();
                    setState(() {});
                  });
                },
                child: const Text("ADD PLAYER",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      )),
    );
  }

  void updatePlayers() {
    var temp = playerdao.getPlayer().then((players) => {
          setState(() {
            playerdao.players = players;
            playerdao.activePlayers.clear();
            for (var player in playerdao.players) {
              if (player.active) {
                playerdao.activePlayers.add(player);
              }
            }
          })
        });
  }

  void getTasks() async {
    var temp = taskdao.getTask().then((tasks) => {
          setState(() {
            taskdao.tasks = tasks;
            getText().then((text) => {
                  setState(() {
                    tasktext = text;
                  })
                });
          })
        });
  }

  List<Player> randomPlayers(int taskindex) {
    List<Player> currplayers = [];
    for (int i = 0; i < taskdao.tasks[taskindex].numberOfPlayers; i++) {
      Player random =
          playerdao.activePlayers[rand.nextInt(playerdao.activePlayers.length)];
      while (currplayers.contains(random)) {
        random = playerdao
            .activePlayers[rand.nextInt(playerdao.activePlayers.length)];
      }
      currplayers.add(random);
    }
    return currplayers;
  }

  Future<String> getText() async {
    if (taskdao.tasks.length == 0 || playerdao.activePlayers.length == 0) {
      return "PUSH NEEEEXT TO START THE GAME";
    }
    int taskindex = rand.nextInt(taskdao.tasks.length);
    if (taskdao.tasks[taskindex].numberOfPlayers == 0) {
      return taskdao.tasks[taskindex].text;
    } else {
      List<String> tasktext = taskdao.tasks[taskindex].text.split(';');
      List<Player> currplayers = randomPlayers(taskindex);
      if (taskdao.tasks[taskindex].numberOfPlayers == 1) {
        return tasktext[0] + currplayers[0].name + tasktext[1];
      } else if (taskdao.tasks[taskindex].numberOfPlayers == 2) {
        return tasktext[0] +
            currplayers[0].name +
            tasktext[1] +
            currplayers[1].name +
            tasktext[2];
      }
      return "Invalid text";
    }
  }
}
