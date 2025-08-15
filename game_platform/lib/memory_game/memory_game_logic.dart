import 'dart:math';

enum GameShape { circle, triangle, square, club, heart }

enum GameState { showingSequence, waitingForInput, won, lost }

class MemoryGameLogic {
  final Random _random = Random();
  final List<GameShape> sequence = [];
  final List<GameShape> allShapes = GameShape.values;

  int currentUserIndex = 0;
  GameState gameState = GameState.showingSequence;

  void generateSequence(int length) {
    sequence.clear();
    for (int i = 0; i < length; i++) {
      sequence.add(allShapes[_random.nextInt(allShapes.length)]);
    }
    currentUserIndex = 0;
    gameState = GameState.showingSequence;
  }

  void startUserInputPhase() {
    gameState = GameState.waitingForInput;
  }

  bool checkGuess(GameShape shape) {
    if (gameState != GameState.waitingForInput || currentUserIndex >= sequence.length) {
      return false;
    }

    if (sequence[currentUserIndex] == shape) {
      currentUserIndex++;
      if (currentUserIndex == sequence.length) {
        gameState = GameState.won;
      }
      return true;
    } else {
      gameState = GameState.lost;
      return false;
    }
  }
}
