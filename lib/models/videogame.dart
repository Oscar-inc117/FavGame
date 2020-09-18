class VideoGame {
  String id;
  String name;
  int votes;

  VideoGame({this.id, this.name, this.votes});

  factory VideoGame.fromMap(Map<String, dynamic> obj) =>
      VideoGame(id: obj['id'], name: obj['name'], votes: obj['votes']);
}
