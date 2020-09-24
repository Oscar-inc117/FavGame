import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:fav_game/models/videogame.dart';
import 'package:fav_game/services/socket.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<VideoGame> videogames = [];

  @override
  void initState() {
    final socketService = Provider.of<Socket>(context, listen: false);

    socketService.socket.on('videogames', _handleVideoGames);
    super.initState();
  }

  _handleVideoGames(dynamic data) {
    this.videogames = (data as List)
        .map((videogame) => VideoGame.fromMap(videogame))
        .toList();

    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<Socket>(context, listen: false);

    socketService.socket.off('videogames');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<Socket>(context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('FavGame', style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
          elevation: 1,
          actions: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 10),
                child: (socketService.serverStatus == ServerStatus.Online
                    ? Icon(Icons.offline_bolt, color: Colors.green)
                    : Icon(Icons.offline_bolt, color: Colors.red)))
          ],
        ),
        body: Column(
          children: <Widget>[
            _showGraph(),
            Expanded(
              child: ListView.builder(
                  itemCount: videogames.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _videoGameTile(videogames[index])),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          elevation: 1,
          onPressed: addNewVideoGame,
        ));
  }

  Widget _videoGameTile(VideoGame videogame) {
    final socketService = Provider.of<Socket>(context, listen: false);

    return Dismissible(
      key: Key(videogame.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) =>
          socketService.socket.emit('delete-videogame', {'id': videogame.id}),
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child:
              Text('Delete Video Game', style: TextStyle(color: Colors.white)),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(videogame.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(videogame.name),
        trailing: Text('${videogame.votes}', style: TextStyle(fontSize: 20.0)),
        onTap: () =>
            socketService.socket.emit('vote-videogame', {'id': videogame.id}),
      ),
    );
  }

  addNewVideoGame() {
    final TextEditingController textController = new TextEditingController();

    if (Platform.isIOS) {
      return showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: Text('New Video Game'),
                content: CupertinoTextField(controller: textController),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text('Add'),
                    onPressed: () => addVideoGameToList(textController.text),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: Text('Dismiss'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ));
    }

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('New Video Game'),
              content: TextField(controller: textController),
              actions: <Widget>[
                MaterialButton(
                  child: Text('Add'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => addVideoGameToList(textController.text),
                )
              ],
            ));
  }

  void addVideoGameToList(String name) {
    final socketService = Provider.of<Socket>(context, listen: false);

    if (name.length >= 1) {
      //add to list
      socketService.socket.emit('add-videogame', {'name': name});
      /*this.videogames.add(
          new VideoGame(id: DateTime.now().toString(), name: name, votes: 0));*/
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
    videogames.forEach((videogame) {
      dataMap.putIfAbsent(videogame.name, () => videogame.votes.toDouble());
    });

    return Container(
        width: double.infinity, height: 200, child: PieChart(dataMap: dataMap));
  }
}
