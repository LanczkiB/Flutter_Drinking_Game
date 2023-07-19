import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../data/player.dart';
import '../../data/players_dao.dart';
import '../helper/dialog.dart';

class PlayerSettings extends StatelessWidget {
  const PlayerSettings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  var playerdao;

  @override
  void initState() {
    super.initState();
    playerdao = context.read<PlayerDao>();
    updatePlayers();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Theme.of(context).colorScheme.primary;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
          Widget>[
        Container(
            padding:
                const EdgeInsets.only(left: 0, top: 50, right: 0, bottom: 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 2.0,
                        color: Theme.of(context).colorScheme.secondary))),
            child: const Text("SELECTED PLAYERS",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold))),
        Expanded(
          child: Consumer<PlayerDao>(
            builder: (context, playerdao, child) {
              return ListView.builder(
                itemCount: playerdao.activePlayers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Text(
                          playerdao.activePlayers[index].name,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        )
                      ]));
                },
              );
            },
          ),
        ),
        Container(
            padding: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 2.0,
                        color: Theme.of(context).colorScheme.secondary))),
            child: const Text("ALL PLAYERS",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold))),
        Expanded(
          child: Consumer<PlayerDao>(
            builder: (context, playerdao, child) {
              return ListView.builder(
                itemCount: playerdao.players.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    subtitle: Transform.translate(
                        offset: const Offset(0, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                value: playerdao.players[index].active,
                                onChanged: (bool? value) {
                                  setState(() {
                                    playerdao.updatePlayerActivity(
                                      playerdao.players[index].name,
                                      !playerdao.players[index].active,
                                    );
                                    updatePlayers();
                                  });
                                },
                              ),
                              Text(
                                playerdao.players[index].name,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 30),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_rounded),
                                iconSize: 50,
                                onPressed: () {
                                  setState(() {
                                    playerdao.removePlayer(index);
                                    updatePlayers();
                                  });
                                },
                              )
                            ])),
                  );
                },
              );
            },
          ),
        ),
        Container(
            padding:
                const EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(20)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width: 3.0))),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/game");
                    },
                    child: const Text("START GAME",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold))),
                TextButton(
                  onPressed: () {
                    AddPlayerDialog(context, "ADD NAME:", playerdao)
                        .then((onValue) {
                      playerdao.players.add(Player(onValue, false));
                      playerdao.savePlayer(Player(onValue, false));
                      setState(() {});
                    });
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(20)),
                  ),
                  child: const Text("NEW PLAYER",
                      style: TextStyle(fontSize: 25, color: Colors.black)),
                ),
              ],
            )),
      ]),
    );
  }

  void updatePlayers() {
    var temp = playerdao.getPlayer().then((posts) => {
          setState(() {
            playerdao.players = posts;
            playerdao.activePlayers.clear();
            for (var player in playerdao.players) {
              if (player.active) {
                playerdao.activePlayers.add(player);
              }
            }
          })
        });
  }
}
