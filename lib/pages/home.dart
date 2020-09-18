import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fav_game/models/videogame.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<VideoGame> videogames = [
    VideoGame(id: '1', name: 'GTA V', votes: 7),
    VideoGame(id: '2', name: 'Among Us', votes: 4),
    VideoGame(id: '3', name: 'Fortnite', votes: 5),
    VideoGame(id: '4', name: 'Cod Warzone', votes: 6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('FavGame', style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: ListView.builder(
            itemCount: videogames.length,
            itemBuilder: (BuildContext context, int index) =>
                _bandTile(videogames[index])),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          elevation: 1,
          onPressed: addNewBand,
        ));
  }

  Widget _bandTile(VideoGame videogame) {
    return Dismissible(
      key: Key(videogame.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        print('direction $direction');
        print('id:${videogame.id}');
      },
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
        onTap: () {
          print(videogame.name);
        },
      ),
    );
  }

  addNewBand() {
    final TextEditingController textController = new TextEditingController();

    if (Platform.isIOS) {
      return showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: Text('New Video Game'),
              content: CupertinoTextField(controller: textController),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Add'),
                  onPressed: () => addBandToList(textController.text),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text('Dismiss'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            );
          });
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Video Game'),
          content: TextField(controller: textController),
          actions: <Widget>[
            MaterialButton(
              child: Text('Add'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () => addBandToList(textController.text),
            )
          ],
        );
      },
    );
  }

  void addBandToList(String name) {
    print(name);

    if (name.length >= 1) {
      //add to list
      this.videogames.add(
          new VideoGame(id: DateTime.now().toString(), name: name, votes: 2));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
