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
}
