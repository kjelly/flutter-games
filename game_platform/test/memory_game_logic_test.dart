import 'package:flutter_test/flutter_test.dart';
import 'package:game_platform/memory_game/memory_game_logic.dart';

void main() {
  group('MemoryGameLogic', () {
    late MemoryGameLogic gameLogic;

    setUp(() {
      gameLogic = MemoryGameLogic();
    });

    group('startNewGame', () {
      test('should select the correct number of active emojis', () {
        gameLogic.startNewGame(5, 7);
        expect(gameLogic.activeEmojis.length, 7);
        // Check for uniqueness
        expect(gameLogic.activeEmojis.toSet().length, 7);
      });

      test('should generate a sequence of the initial length', () {
        gameLogic.startNewGame(5, 7);
        expect(gameLogic.sequence.length, 5);
        expect(gameLogic.currentLength, 5);
        // Check that the sequence only contains emojis from the active set
        for (var emoji in gameLogic.sequence) {
          expect(gameLogic.activeEmojis.contains(emoji), isTrue);
        }
      });
    });

    group('increaseLevel', () {
      test('should increment currentLength and generate a new sequence', () {
        gameLogic.startNewGame(3, 5);
        expect(gameLogic.currentLength, 3);

        gameLogic.increaseLevel();
        expect(gameLogic.currentLength, 4);
        expect(gameLogic.sequence.length, 4);
      });
    });

    group('regenerateSequence', () {
      test('should generate a new sequence of the same length', () {
        gameLogic.startNewGame(3, 5);
        final firstSequence = List.from(gameLogic.sequence);
        expect(gameLogic.currentLength, 3);

        gameLogic.regenerateSequence();
        expect(gameLogic.currentLength, 3); // Length should not change
        expect(gameLogic.sequence.length, 3);
        // It's possible, but highly unlikely, that the sequence is identical.
        // A better test would be to check if the sequence object is different,
        // but for this purpose, we assume the content will likely change.
        expect(gameLogic.sequence, isNot(equals(firstSequence)));
      });
    });

    group('checkGuess', () {
      setUp(() {
        gameLogic.startNewGame(3, 5);
        // Manually set a predictable sequence and active emojis for testing
        gameLogic.activeEmojis = ['😀', '👍', '🚀', '🍕', '🐶'];
        gameLogic.sequence.clear();
        gameLogic.sequence.addAll(['😀', '🚀', '👍']);
        gameLogic.startUserInputPhase();
      });

      test('should return true for correct guesses', () {
        expect(gameLogic.checkGuess('😀'), isTrue);
        expect(gameLogic.checkGuess('🚀'), isTrue);
      });

      test('should change state to "won" after the last correct guess', () {
        gameLogic.checkGuess('😀');
        gameLogic.checkGuess('🚀');
        expect(gameLogic.checkGuess('👍'), isTrue);
        expect(gameLogic.gameState, GameState.won);
      });

      test('should return false for incorrect guess and change state to "lost"', () {
        expect(gameLogic.checkGuess('🍕'), isFalse);
        expect(gameLogic.gameState, GameState.lost);
      });
    });
  });
}
