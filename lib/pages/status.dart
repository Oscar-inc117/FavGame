import 'package:fav_game/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<Socket>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('ServerStatus: ${socket.serverStatus}')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          onPressed: () {
            socket.socket.emit('emit-message',
                {'name': 'Lebron James Jarden', 'message': 'what it do baby'});
          }),
    );
  }
}
