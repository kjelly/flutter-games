import 'package:flutter/material.dart';
import 'one_a_two_b_logic.dart';

class OneATwoBScreen extends StatefulWidget {
  const OneATwoBScreen({Key? key}) : super(key: key);

  @override
  _OneATwoBScreenState createState() => _OneATwoBScreenState();
}

class _OneATwoBScreenState extends State<OneATwoBScreen> {
  final OneATwoBLogic _gameLogic = OneATwoBLogic();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _feedbackMessage = '';
  bool _isGameWon = false;

  @override
  void initState() {
    super.initState();
    _gameLogic.generateSecretNumber();
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
    if (_isGameWon) return;

    final userGuess = _controller.text;

    if (!_gameLogic.isGuessValid(userGuess)) {
      setState(() {
        _feedbackMessage = 'Invalid guess. Please enter 4 unique digits.';
      });
      _controller.clear();
      _focusNode.requestFocus();
      return;
    }

    final result = _gameLogic.checkGuess(userGuess);
    setState(() {
      if (result == '4A0B') {
        _isGameWon = true;
        _feedbackMessage = 'Congratulations! You guessed the number in ${_gameLogic.attempts} attempts.';
      } else {
        _feedbackMessage = ''; // Clear previous feedback
      }
    });
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _startNewGame() {
    setState(() {
      _gameLogic.generateSecretNumber();
      _feedbackMessage = '';
      _isGameWon = false;
      _controller.clear();
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final reversedHistory = _gameLogic.history.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('1A2B Guessing Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: reversedHistory.length,
                itemBuilder: (context, index) {
                  final item = reversedHistory[index];
                  return ListTile(
                    title: Text('Guess: ${item.guess}'),
                    trailing: Text('Result: ${item.result}'),
                  );
                },
              ),
            ),
            if (_feedbackMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _feedbackMessage,
                  style: TextStyle(
                    fontSize: 18,
                    color: _isGameWon ? Colors.green : Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: const InputDecoration(
                      labelText: 'Your 4-digit guess',
                      counterText: "", // Hide the counter
                    ),
                    onSubmitted: (_) => _checkGuess(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isGameWon ? null : _checkGuess,
                  child: const Text('Guess'),
                ),
              ],
            ),
            if (_isGameWon)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: _startNewGame,
                  child: const Text('Play Again'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
