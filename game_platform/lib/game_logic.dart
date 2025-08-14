import 'dart:math';

enum Operation { add, subtract, multiply }

extension OperationExtension on Operation {
  String get operator {
    switch (this) {
      case Operation.add:
        return '+';
      case Operation.subtract:
        return '-';
      case Operation.multiply:
        return '*';
    }
  }
}

class MathGameLogic {
  int number1 = 0;
  int number2 = 0;
  Operation operation = Operation.add;
  int answer = 0;

  void generateQuestion() {
    final random = Random();
    number1 = random.nextInt(100) + 1;
    number2 = random.nextInt(100) + 1;

    if (number1 < number2) {
      final temp = number1;
      number1 = number2;
      number2 = temp;
    }

    operation = Operation.values[random.nextInt(Operation.values.length)];

    switch (operation) {
      case Operation.add:
        answer = number1 + number2;
        break;
      case Operation.subtract:
        answer = number1 - number2;
        break;
      case Operation.multiply:
        answer = number1 * number2;
        break;
    }
  }
}
