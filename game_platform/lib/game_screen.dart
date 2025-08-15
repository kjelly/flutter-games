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
  final ValueNotifier<String> _feedbackMessage = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _gameLogic.generateQuestion();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _feedbackMessage.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final userAnswerText = _controller.text;
    final userAnswer = int.tryParse(userAnswerText);
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());

    if (userAnswer == null) {
      _feedbackMessage.value = 'Invalid Input. Please enter a number.';
      _controller.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
      return;
    }

    setState(() {
      _gameLogic.totalQuestions++;
      if (userAnswer == _gameLogic.answer) {
        _gameLogic.correctAnswers++;
        if (_gameLogic.questionStartTime != null) {
          final responseTime = DateTime.now().difference(_gameLogic.questionStartTime!);
          _gameLogic.totalResponseTime += responseTime.inSeconds;
        }
        _feedbackMessage.value = 'Correct!';
        // After a short delay, generate a new question.
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _gameLogic.generateQuestion();
              _controller.clear();
            });
            _feedbackMessage.value = '';
            WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
          }
        });
      } else {
        _feedbackMessage.value =
            'Wrong! You answered $userAnswerText, but the correct answer is ${_gameLogic.answer}.';
        _controller.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
      }
    });
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Accuracy: ${_gameLogic.accuracy.toStringAsFixed(2)}%'),
                Text('Avg Speed: ${_gameLogic.averageResponseTime.toStringAsFixed(2)}s'),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '${_gameLogic.number1} ${_gameLogic.operation.operator} ${_gameLogic.number2} = ?',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.send,
              decoration: const InputDecoration(
                labelText: 'Your Answer',
              ),
              onSubmitted: (_) => _checkAnswer(),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<String>(
              valueListenable: _feedbackMessage,
              builder: (context, message, child) {
                return Text(
                  message,
                  style: TextStyle(
                    fontSize: 18,
                    color: message == 'Correct!' ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
