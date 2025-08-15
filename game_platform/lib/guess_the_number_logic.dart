import 'dart:math';

enum GuessResult { tooHigh, tooLow, correct }

class GuessTheNumberLogic {
  final _random = Random();
  int _secretNumber = 0;
  int _attempts = 0;

  int get attempts => _attempts;

  void generateNewNumber() {
    _secretNumber = _random.nextInt(100) + 1;
    _attempts = 0;
  }

  GuessResult checkGuess(int guess) {
    _attempts++;
    if (guess > _secretNumber) {
      return GuessResult.tooHigh;
    } else if (guess < _secretNumber) {
      return GuessResult.tooLow;
    } else {
      return GuessResult.correct;
    }
  }
}
