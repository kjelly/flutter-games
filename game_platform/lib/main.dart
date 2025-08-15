import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'guess_the_number_screen.dart';
import 'one_a_two_b_screen.dart';

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
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Game Platform'),
        '/game/math': (context) => const GameScreen(),
        '/game/guess-the-number': (context) => const GuessTheNumberScreen(),
        '/game/1a2b': (context) => const OneATwoBScreen(),
      },
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
              Navigator.pushNamed(context, '/game/math');
            },
          ),
          ListTile(
            title: const Text('Guess the Number'),
            onTap: () {
              Navigator.pushNamed(context, '/game/guess-the-number');
            },
          ),
          ListTile(
            title: const Text('1A2B Guessing Game'),
            onTap: () {
              Navigator.pushNamed(context, '/game/1a2b');
            },
          ),
        ],
      ),
    );
  }
}
