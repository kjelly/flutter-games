import 'package:flutter_test/flutter_test.dart';
import 'package:game_platform/memory_game/memory_game_logic.dart';

void main() {
  group('MemoryGameLogic', () {
    late MemoryGameLogic gameLogic;

    setUp(() {
      gameLogic = MemoryGameLogic();
    });

    group('startNewGame', () {
      test('should generate a sequence of the initial length', () {
        gameLogic.startNewGame(5);
        expect(gameLogic.sequence.length, 5);
        expect(gameLogic.currentLength, 5);
      });

      test('should reset game state', () {
        gameLogic.gameState = GameState.won;
        gameLogic.currentUserIndex = 3;

        gameLogic.startNewGame(5);

        expect(gameLogic.gameState, GameState.showingSequence);
        expect(gameLogic.currentUserIndex, 0);
      });
    });

    group('nextLevel', () {
      test('should increment currentLength and generate a new sequence', () {
        gameLogic.startNewGame(3);
        expect(gameLogic.currentLength, 3);

        gameLogic.nextLevel();
        expect(gameLogic.currentLength, 4);
        expect(gameLogic.sequence.length, 4);
        expect(gameLogic.gameState, GameState.showingSequence);
        expect(gameLogic.currentUserIndex, 0);
      });
    });

    group('startUserInputPhase', () {
      test('should change gameState to waitingForInput', () {
        gameLogic.startUserInputPhase();
        expect(gameLogic.gameState, GameState.waitingForInput);
      });
    });

    group('checkGuess', () {
      setUp(() {
        gameLogic.startNewGame(3);
        // Manually set a predictable sequence for testing
        gameLogic.sequence.clear();
        gameLogic.sequence.addAll([
          GameShape.circle,
          GameShape.square,
          GameShape.heart,
        ]);
        gameLogic.startUserInputPhase();
      });

      test('should return true for correct guesses and update state', () {
        expect(gameLogic.checkGuess(GameShape.circle), isTrue);
        expect(gameLogic.currentUserIndex, 1);
        expect(gameLogic.gameState, GameState.waitingForInput);

        expect(gameLogic.checkGuess(GameShape.square), isTrue);
        expect(gameLogic.currentUserIndex, 2);
        expect(gameLogic.gameState, GameState.waitingForInput);
      });

      test('should change state to "won" after the last correct guess', () {
        gameLogic.checkGuess(GameShape.circle);
        gameLogic.checkGuess(GameShape.square);
        expect(gameLogic.checkGuess(GameShape.heart), isTrue);

        expect(gameLogic.currentUserIndex, 3);
        expect(gameLogic.gameState, GameState.won);
      });

      test('should return false for incorrect guess and change state to "lost"', () {
        expect(gameLogic.checkGuess(GameShape.triangle), isFalse);
        expect(gameLogic.currentUserIndex, 0); // Index should not advance
        expect(gameLogic.gameState, GameState.lost);
      });

      test('should not allow guesses when game is won or lost', () {
        gameLogic.checkGuess(GameShape.triangle); // Game is now lost
        expect(gameLogic.gameState, GameState.lost);

        expect(gameLogic.checkGuess(GameShape.circle), isFalse); // Further guesses are ignored
      });
    });
  });
}
