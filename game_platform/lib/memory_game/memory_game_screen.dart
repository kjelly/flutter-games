import 'dart:async';
import 'package:flutter/material.dart';
import 'memory_game_logic.dart';
import 'shape_widget.dart';
import 'shape_button.dart';

class MemoryGameScreen extends StatefulWidget {
  final int sequenceLength;
  final int displayDurationInSeconds;

  const MemoryGameScreen({
    Key? key,
    required this.sequenceLength,
    required this.displayDurationInSeconds,
  }) : super(key: key);

  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  final MemoryGameLogic _gameLogic = MemoryGameLogic();
  Timer? _timer;
  String _message = "Memorize the sequence...";

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _gameLogic.generateSequence(widget.sequenceLength);
    _message = "Memorize the sequence...";
    _timer = Timer(Duration(seconds: widget.displayDurationInSeconds), () {
      if (mounted) {
        setState(() {
          _gameLogic.startUserInputPhase();
          _message = "Your turn...";
        });
      }
    });
  }

  void _handleGuess(GameShape shape) {
    if (_gameLogic.gameState != GameState.waitingForInput) return;

    final isCorrect = _gameLogic.checkGuess(shape);
    setState(() {
      if (_gameLogic.gameState == GameState.won) {
        _message = "Congratulations! You won!";
      } else if (_gameLogic.gameState == GameState.lost) {
        _message = "Wrong! You lost. Try again!";
      } else if (isCorrect) {
        // Optionally give feedback for each correct press
        // _message = "Correct!";
      }
    });
  }

  void _playAgain() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Message area
              Text(
                _message,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Game area (sequence or buttons)
              _buildGameArea(),

              const SizedBox(height: 40),

              // Action button (Play Again)
              if (_gameLogic.gameState == GameState.won || _gameLogic.gameState == GameState.lost)
                ElevatedButton(
                  onPressed: _playAgain,
                  child: const Text('Play Again'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameArea() {
    switch (_gameLogic.gameState) {
      case GameState.showingSequence:
        return Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          alignment: WrapAlignment.center,
          children: _gameLogic.sequence
              .map((shape) => ShapeWidget(shape: shape, size: 60))
              .toList(),
        );
      case GameState.waitingForInput:
        return Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          alignment: WrapAlignment.center,
          children: GameShape.values
              .map((shape) => ShapeButton(
                    shape: shape,
                    onPressed: () => _handleGuess(shape),
                  ))
              .toList(),
        );
      case GameState.won:
      case GameState.lost:
        // Show the sequence that was the answer
        return Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          alignment: WrapAlignment.center,
          children: _gameLogic.sequence
              .map((shape) => ShapeWidget(shape: shape, size: 60))
              .toList(),
        );
    }
  }
}
