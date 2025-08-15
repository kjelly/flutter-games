import 'dart:math';

class GuessHistory {
  final String guess;
  final String result;

  GuessHistory(this.guess, this.result);
}

class OneATwoBLogic {
  final _random = Random();
  String secretNumber = '';
  int attempts = 0;
  final List<GuessHistory> history = [];

  void generateSecretNumber() {
    final digits = List.generate(10, (i) => i.toString());
    digits.shuffle(_random);
    secretNumber = digits.sublist(0, 4).join();
    attempts = 0;
    history.clear();
  }

  String checkGuess(String guess) {
    attempts++;
    int a = 0;
    int b = 0;

    for (int i = 0; i < 4; i++) {
      if (guess[i] == secretNumber[i]) {
        a++;
      } else if (secretNumber.contains(guess[i])) {
        b++;
      }
    }

    final result = '${a}A${b}B';
    history.add(GuessHistory(guess, result));
    return result;
  }

  bool isGuessValid(String guess) {
    if (guess.length != 4) {
      return false;
    }
    if (int.tryParse(guess) == null) {
      return false;
    }
    final seen = <String>{};
    for (final char in guess.split('')) {
      if (!seen.add(char)) {
        return false;
      }
    }
    return true;
  }
}
