class Task {
  late String text;
  late int numberOfPlayers;

  Task(this.text, this.numberOfPlayers);

  Task.fromJson(Map<String, int> json)
      : text = json['text'] as String,
        numberOfPlayers = json['playnum'] as int;

  Task createTask(taskvalue) {
    Map<String, dynamic> attributes = {'text': '', 'numberOfPlayers': 0};
    taskvalue.forEach((key, value) => {attributes[key] = value});
    Task task = Task(attributes['text'], attributes['playnum']);
    return task;
  }
}
