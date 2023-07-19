import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'player.dart';

class PlayerDao extends ChangeNotifier {
  late List<Player> players = [];
  late List<Player> activePlayers = [];
  final dao = FirebaseDatabase.instance.reference().child('players/');
  var kDebugMode = false;

  void savePlayer(Player player) {
    dao.child(player.name).set(player.toJson()).catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    }).then((value) {
      if (kDebugMode) {
        print("Successful player adding");
      }
    });
  }

  void updatePlayerActivity(String name, bool boolean) async {
    await dao.child(name).update({"active": boolean});
    notifyListeners();
  }

  void removePlayer(index) async {
    await dao.child(players[index].name).remove();
    notifyListeners();
  }

  Future<List<Player>> getPlayer() async {
    DataSnapshot dataSnapshot = await dao.once();
    List<Player> temp = [];
    if (dataSnapshot.value != null) {
      dataSnapshot.value.forEach((key, value) {
        Player player = Player("", false).createPlayer(value);
        temp.add(player);
      });
    }
    return temp;
  }
}
