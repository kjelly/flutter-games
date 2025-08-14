import 'package:flutter/material.dart';
import 'game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Platform',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Game Platform'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Math Challenge'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GameScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
