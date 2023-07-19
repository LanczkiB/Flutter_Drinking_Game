class Player {
  late String name;
  late bool active;

  Player(this.name, this.active);

  Player.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        active = false;

  Player createPlayer(playervalue) {
    Map<String, dynamic> attributes = {'name': '', 'activity': false};
    playervalue.forEach((key, value) => {attributes[key] = value});
    Player player = Player(attributes['name'], attributes['active']);
    return player;
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'name': name, 'active': active};
}
