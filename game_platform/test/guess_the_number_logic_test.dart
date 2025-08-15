import 'package:flutter_test/flutter_test.dart';
import 'package:game_platform/guess_the_number_logic.dart';

void main() {
  group('GuessTheNumberLogic', () {
    late GuessTheNumberLogic gameLogic;

    setUp(() {
      gameLogic = GuessTheNumberLogic();
      gameLogic.generateNewNumber();
    });

    test('generateNewNumber should reset attempts', () {
      gameLogic.checkGuess(50);
      expect(gameLogic.attempts, 1);
      gameLogic.generateNewNumber();
      expect(gameLogic.attempts, 0);
    });

    test('checkGuess returns correct result for a low guess', () {
      final secretNumber = gameLogic.checkGuess(0);
      expect(secretNumber, equals(GuessResult.tooLow));
    });

    test('checkGuess returns correct result for a high guess', () {
      final secretNumber = gameLogic.checkGuess(101);
      expect(secretNumber, equals(GuessResult.tooHigh));
    });

    test('attempts should increment after each guess', () {
      expect(gameLogic.attempts, 0);
      gameLogic.checkGuess(50);
      expect(gameLogic.attempts, 1);
      gameLogic.checkGuess(75);
      expect(gameLogic.attempts, 2);
    });
  });
}
