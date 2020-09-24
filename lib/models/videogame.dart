class VideoGame {
  String id;
  String name;
  int votes;

  VideoGame({this.id, this.name, this.votes});

  factory VideoGame.fromMap(Map<String, dynamic> obj) => VideoGame(
      id: obj.containsKey('id') ? obj['id'] : 'no-id',
      name: obj.containsKey('name') ? obj['name'] : 'no-name',
      votes: obj.containsKey('votes') ? obj['votes'] : 'no-votes');
}
