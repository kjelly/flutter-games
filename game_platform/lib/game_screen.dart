import 'package:flutter/material.dart';
import 'game_logic.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final MathGameLogic _gameLogic = MathGameLogic();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _gameLogic.generateQuestion();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showResultDialog({
    required String title,
    Widget? content,
    required List<Widget> actions,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content,
        actions: actions,
      ),
    );
  }

  void _checkAnswer() {
    final userAnswer = int.tryParse(_controller.text);
    if (userAnswer == null) {
      _showResultDialog(
        title: 'Invalid Input',
        content: const Text('Please enter a valid number.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      );
      return;
    }

    if (userAnswer == _gameLogic.answer) {
      _showResultDialog(
        title: 'Correct!',
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (mounted) {
                setState(() {
                  _gameLogic.generateQuestion();
                  _controller.clear();
                });
              }
            },
            child: const Text('Next Question'),
          ),
        ],
      );
    } else {
      _showResultDialog(
        title: 'Wrong!',
        content: Text('The correct answer is ${_gameLogic.answer}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Try Again'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Challenge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${_gameLogic.number1} ${_gameLogic.operation.operator} ${_gameLogic.number2} = ?',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Your Answer',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: const Text('Check Answer'),
            ),
          ],
        ),
      ),
    );
  }
}
