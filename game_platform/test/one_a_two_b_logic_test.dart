import 'package:flutter_test/flutter_test.dart';
import 'package:game_platform/one_a_two_b_logic.dart';

void main() {
  group('OneATwoBLogic', () {
    late OneATwoBLogic gameLogic;

    setUp(() {
      gameLogic = OneATwoBLogic();
    });

    group('generateSecretNumber', () {
      test('should generate a 4-digit number with unique digits', () {
        gameLogic.generateSecretNumber();
        final number = gameLogic.secretNumber;

        expect(number.length, 4);
        final uniqueChars = number.split('').toSet();
        expect(uniqueChars.length, 4);
      });

      test('should reset attempts and history', () {
        gameLogic.generateSecretNumber();
        gameLogic.checkGuess('1234');

        expect(gameLogic.attempts, 1);
        expect(gameLogic.history.length, 1);

        gameLogic.generateSecretNumber();

        expect(gameLogic.attempts, 0);
        expect(gameLogic.history.isEmpty, isTrue);
      });
    });

    group('isGuessValid', () {
      test('should return true for valid guesses', () {
        expect(gameLogic.isGuessValid('1234'), isTrue);
        expect(gameLogic.isGuessValid('0987'), isTrue);
      });

      test('should return false for invalid guesses', () {
        expect(gameLogic.isGuessValid('123'), isFalse, reason: 'Too short');
        expect(gameLogic.isGuessValid('12345'), isFalse, reason: 'Too long');
        expect(gameLogic.isGuessValid('123a'), isFalse, reason: 'Contains non-digits');
        expect(gameLogic.isGuessValid('1223'), isFalse, reason: 'Contains duplicates');
      });
    });

    group('checkGuess', () {
      setUp(() {
        gameLogic.secretNumber = '1234';
        gameLogic.attempts = 0;
        gameLogic.history.clear();
      });

      test('should return 4A0B for correct guess', () {
        expect(gameLogic.checkGuess('1234'), '4A0B');
      });

      test('should return 0A0B for completely wrong guess', () {
        expect(gameLogic.checkGuess('5678'), '0A0B');
      });

      test('should return correct A and B values', () {
        expect(gameLogic.checkGuess('1243'), '2A2B');
        expect(gameLogic.checkGuess('4321'), '0A4B');
        expect(gameLogic.checkGuess('1567'), '1A0B');
        expect(gameLogic.checkGuess('5167'), '0A1B');
        expect(gameLogic.checkGuess('1325'), '1A2B');
      });

      test('should update history and attempts', () {
        gameLogic.checkGuess('1234');
        expect(gameLogic.attempts, 1);
        expect(gameLogic.history.length, 1);
        expect(gameLogic.history.first.guess, '1234');
        expect(gameLogic.history.first.result, '4A0B');

        gameLogic.checkGuess('5678');
        expect(gameLogic.attempts, 2);
        expect(gameLogic.history.length, 2);
        expect(gameLogic.history.last.guess, '5678');
        expect(gameLogic.history.last.result, '0A0B');
      });
    });
  });
}
