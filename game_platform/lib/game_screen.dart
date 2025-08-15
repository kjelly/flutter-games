import 'package:flutter/material.dart';
import 'dart:async';
import 'game_logic.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final MathGameLogic _gameLogic = MathGameLogic();
  final TextEditingController _controller = TextEditingController();
  String _feedbackMessage = '';

  @override
  void initState() {
    super.initState();
    _gameLogic.generateQuestion();
    _controller.addListener(() {
      if (_feedbackMessage.isNotEmpty) {
        setState(() {
          _feedbackMessage = '';
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final userAnswer = int.tryParse(_controller.text);
    if (userAnswer == null) {
      setState(() {
        _feedbackMessage = 'Invalid Input. Please enter a number.';
      });
      return;
    }

    if (userAnswer == _gameLogic.answer) {
      setState(() {
        _feedbackMessage = 'Correct!';
      });
      // After a short delay, generate a new question.
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _gameLogic.generateQuestion();
            _controller.clear();
            _feedbackMessage = '';
          });
        }
      });
    } else {
      setState(() {
        _feedbackMessage = 'Wrong! The correct answer is ${_gameLogic.answer}.';
      });
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
            const SizedBox(height: 20),
            Text(
              _feedbackMessage,
              style: TextStyle(
                fontSize: 18,
                color: _feedbackMessage == 'Correct!' ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
