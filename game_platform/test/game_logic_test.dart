import 'package:flutter_test/flutter_test.dart';
import 'package:game_platform/game_logic.dart';

void main() {
  test('generateQuestion should produce a valid question', () {
    final gameLogic = MathGameLogic();
    gameLogic.generateQuestion();

    expect(gameLogic.number1, greaterThan(0));
    expect(gameLogic.number1, lessThanOrEqualTo(100));
    expect(gameLogic.number2, greaterThan(0));
    expect(gameLogic.number2, lessThanOrEqualTo(100));

    expect(gameLogic.operation, isA<Operation>());

    switch (gameLogic.operation) {
      case Operation.add:
        expect(gameLogic.answer, gameLogic.number1 + gameLogic.number2);
        break;
      case Operation.subtract:
        expect(gameLogic.answer, gameLogic.number1 - gameLogic.number2);
        break;
      case Operation.multiply:
        expect(gameLogic.answer, gameLogic.number1 * gameLogic.number2);
        break;
    }
  });

  test('multiplication questions should follow the new rule', () {
    final gameLogic = MathGameLogic();
    for (var i = 0; i < 100; i++) {
      gameLogic.generateQuestion();
      if (gameLogic.operation == Operation.multiply) {
        if (gameLogic.number1 > 10 && gameLogic.number1 < 100) {
          expect(gameLogic.number2, lessThan(10));
        }
      }
    }
  });

  group('statistics', () {
    test('initial values should be correct', () {
      final gameLogic = MathGameLogic();
      expect(gameLogic.correctAnswers, 0);
      expect(gameLogic.totalQuestions, 0);
      expect(gameLogic.totalResponseTime, 0.0);
      expect(gameLogic.accuracy, 0.0);
      expect(gameLogic.averageResponseTime, 0.0);
      expect(gameLogic.questionStartTime, isNull);
    });

    test('generateQuestion should set questionStartTime', () {
      final gameLogic = MathGameLogic();
      gameLogic.generateQuestion();
      expect(gameLogic.questionStartTime, isNotNull);
    });

    test('accuracy should be calculated correctly', () {
      final gameLogic = MathGameLogic();
      gameLogic.totalQuestions = 10;
      gameLogic.correctAnswers = 5;
      expect(gameLogic.accuracy, 50.0);
    });

    test('averageResponseTime should be calculated correctly', () {
      final gameLogic = MathGameLogic();
      gameLogic.correctAnswers = 2;
      gameLogic.totalResponseTime = 10.0;
      expect(gameLogic.averageResponseTime, 5.0);
    });
  });
}
