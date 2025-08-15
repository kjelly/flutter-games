import 'package:flutter/material.dart';
import 'guess_the_number_logic.dart';

class GuessTheNumberScreen extends StatefulWidget {
  const GuessTheNumberScreen({Key? key}) : super(key: key);

  @override
  _GuessTheNumberScreenState createState() => _GuessTheNumberScreenState();
}

class _GuessTheNumberScreenState extends State<GuessTheNumberScreen> {
  final GuessTheNumberLogic _gameLogic = GuessTheNumberLogic();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _feedbackMessage = '';
  bool _isGameOngoing = true;

  @override
  void initState() {
    super.initState();
    _gameLogic.generateNewNumber();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _checkGuess() {
    if (!_isGameOngoing) return;

    final userGuessText = _controller.text;
    final userGuess = int.tryParse(userGuessText);
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());

    if (userGuess == null) {
      setState(() {
        _feedbackMessage = 'Invalid Input. Please enter a number.';
      });
      _controller.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
      return;
    }

    final result = _gameLogic.checkGuess(userGuess);
    setState(() {
      switch (result) {
        case GuessResult.tooHigh:
          _feedbackMessage = 'Too high! Try again.';
          break;
        case GuessResult.tooLow:
          _feedbackMessage = 'Too low! Try again.';
          break;
        case GuessResult.correct:
          _feedbackMessage =
              'Correct! You guessed the number in ${_gameLogic.attempts} attempts.';
          _isGameOngoing = false;
          break;
      }
    });
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  void _startNewGame() {
    setState(() {
      _gameLogic.generateNewNumber();
      _feedbackMessage = '';
      _isGameOngoing = true;
      _controller.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guess the Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'I have a secret number between 1 and 100.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Can you guess it?',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              textInputAction: _isGameOngoing ? TextInputAction.send : TextInputAction.none,
              decoration: const InputDecoration(
                labelText: 'Your Guess',
              ),
              onSubmitted: (_) => _checkGuess(),
            ),
            const SizedBox(height: 20),
            Text(
              _feedbackMessage,
              style: TextStyle(
                fontSize: 18,
                color: _isGameOngoing ? Colors.blue : Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (!_isGameOngoing)
              ElevatedButton(
                onPressed: _startNewGame,
                child: const Text('Play Again'),
              ),
          ],
        ),
      ),
    );
  }
}
