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
    _gameLogic.startNewGame(widget.sequenceLength);
    _message = "Memorize the sequence...";
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer(Duration(seconds: widget.displayDurationInSeconds), () {
      if (mounted) {
        setState(() {
          _gameLogic.startUserInputPhase();
          _message = "Your turn...";
        });
      }
    });
  }

  void _startNextRound() {
    setState(() {
      _message = "Correct! Get ready for the next level...";
    });

    // Short delay before showing the next sequence
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && _gameLogic.gameState != GameState.lost) {
        setState(() {
          _gameLogic.nextLevel();
          _message = "Memorize the new sequence...";
          _startTimer();
        });
      }
    });
  }

  void _handleGuess(GameShape shape) {
    if (_gameLogic.gameState != GameState.waitingForInput) return;

    final isCorrect = _gameLogic.checkGuess(shape);

    if (_gameLogic.gameState == GameState.won) {
      _startNextRound();
    } else if (_gameLogic.gameState == GameState.lost) {
      setState(() {
        _message = "Wrong! Game Over.";
      });
    } else if (isCorrect) {
      setState(() {
        // Optional feedback for each correct press, can be empty
      });
    }
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
                "Level: ${_gameLogic.currentLength}",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text(
                _message,
                style: Theme.of(context).textTheme.titleLarge,
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
