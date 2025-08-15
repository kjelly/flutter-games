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
  final FocusNode _focusNode = FocusNode();
  String _feedbackMessage = '';

  @override
  void initState() {
    super.initState();
    _gameLogic.generateQuestion();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final userAnswerText = _controller.text;
    final userAnswer = int.tryParse(userAnswerText);

    if (userAnswer == null) {
      setState(() {
        _feedbackMessage = 'Invalid Input. Please enter a number.';
      });
      _controller.clear();
      _focusNode.requestFocus();
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
        _feedbackMessage =
            'Wrong! You answered $userAnswerText, but the correct answer is ${_gameLogic.answer}.';
      });
      _controller.clear();
      _focusNode.requestFocus();
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
              focusNode: _focusNode,
              autofocus: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.send,
              decoration: const InputDecoration(
                labelText: 'Your Answer',
              ),
              onSubmitted: (_) => _checkAnswer(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              focusNode: FocusNode(canRequestFocus: false),
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
