import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fav_game/pages/home.dart';
import 'package:fav_game/pages/status.dart';
import 'package:fav_game/services/socket.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Socket())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {'home': (_) => HomePage(), 'status': (_) => StatusPage()},
      ),
    );
  }
}
