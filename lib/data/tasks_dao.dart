import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'task.dart';

class TaskDao extends ChangeNotifier {
  late List<Task> tasks = [];
  final dao = FirebaseDatabase.instance.reference().child('tasks/');
  var kDebugMode = false;

  Future<List<Task>> getTask() async {
    DataSnapshot dataSnapshot = await dao.once();
    List<Task> temp = [];
    if (dataSnapshot.value != null) {
      dataSnapshot.value.forEach((key, value) {
        Task task = Task("", 0).createTask(value);
        temp.add(task);
      });
    }
    return temp;
  }
}
