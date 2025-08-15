import 'dart:math';

enum GameState { showingSequence, waitingForInput, won, lost }

const List<String> EMOJI_POOL = [
  '😀', '😂', '😍', '🤔', '😎', '😭', '😡', '👍', '👎', '🙏',
  '🚀', '🚗', '✈️', '⛵️', '🚲', '🛸', '🍔', '🍕', '🍟', '🍦',
  '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐨', '🐯',
  '🍎', '🍊', '🍓', '🍉', '🍇', '🍌', '🍍', '🥝', '🍑', '🍒',
  '⚽️', '🏀', '🏈', '⚾️', '🎾', '🏐', '🎱', '🏓', '🏸', '🏒',
];

class MemoryGameLogic {
  final Random _random = Random();

  // The emojis being used in the current game session
  List<String> activeEmojis = [];

  // The sequence the user needs to memorize
  final List<String> sequence = [];

  int currentUserIndex = 0;
  int currentLength = 0;
  GameState gameState = GameState.showingSequence;

  void _generateSequence() {
    sequence.clear();
    for (int i = 0; i < currentLength; i++) {
      sequence.add(activeEmojis[_random.nextInt(activeEmojis.length)]);
    }
    currentUserIndex = 0;
    gameState = GameState.showingSequence;
  }

  void startNewGame(int initialLength, int numberOfEmojis) {
    // Select a random subset of emojis for this game
    final shuffledPool = List<String>.from(EMOJI_POOL)..shuffle(_random);
    activeEmojis = shuffledPool.sublist(0, numberOfEmojis);

    currentLength = initialLength;
    _generateSequence();
  }

  void nextLevel() {
    currentLength++;
    _generateSequence();
  }

  void startUserInputPhase() {
    gameState = GameState.waitingForInput;
  }

  bool checkGuess(String emoji) {
    if (gameState != GameState.waitingForInput || currentUserIndex >= sequence.length) {
      return false;
    }

    if (sequence[currentUserIndex] == emoji) {
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
