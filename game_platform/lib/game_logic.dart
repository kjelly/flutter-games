import 'dart:math';

class MathGameLogic {
  int number1 = 0;
  int number2 = 0;
  String operation = '+';
  int answer = 0;

  void generateQuestion() {
    final random = Random();
    number1 = random.nextInt(100) + 1;
    number2 = random.nextInt(100) + 1;

    // Ensure number1 is always greater than or equal to number2 for subtraction
    if (number1 < number2) {
      final temp = number1;
      number1 = number2;
      number2 = temp;
    }

    final operations = ['+', '-', '*'];
    operation = operations[random.nextInt(operations.length)];

    switch (operation) {
      case '+':
        answer = number1 + number2;
        break;
      case '-':
        answer = number1 - number2;
        break;
      case '*':
        answer = number1 * number2;
        break;
    }
  }
}
