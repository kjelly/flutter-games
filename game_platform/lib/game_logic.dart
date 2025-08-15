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
  final _random = Random();
  int number1 = 0;
  int number2 = 0;
  Operation operation = Operation.add;
  int answer = 0;
  int correctAnswers = 0;
  int totalQuestions = 0;
  DateTime? questionStartTime;
  double totalResponseTime = 0.0;

  double get accuracy => totalQuestions == 0 ? 0.0 : (correctAnswers / totalQuestions) * 100;
  double get averageResponseTime => correctAnswers == 0 ? 0.0 : totalResponseTime / correctAnswers;

  void generateQuestion() {
    questionStartTime = DateTime.now();
    operation = Operation.values[_random.nextInt(Operation.values.length)];

    if (operation == Operation.multiply) {
      number1 = _random.nextInt(100) + 1;
      if (number1 > 10 && number1 < 100) {
        number2 = _random.nextInt(9) + 1;
      } else {
        number2 = _random.nextInt(100) + 1;
      }
    } else {
      number1 = _random.nextInt(100) + 1;
      number2 = _random.nextInt(100) + 1;
    }

    if (number1 < number2) {
      final temp = number1;
      number1 = number2;
      number2 = temp;
    }

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
